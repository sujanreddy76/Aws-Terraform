//VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "jenkins-vpc"
  }

}
//Public-Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  count  = length(var.subnet_availability_zones)
  //For Example: 10.0.0.0/16
  //cidrsubnet(10.0.0.0/16, 8, 0+1) => 10.0.1.0/24
  //cidrsubnet(10.0.0.0/16, 8, 1+1) => 10.0.2.0/24
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.subnet_availability_zones, count.index)
  tags = {
    Name = "jenkins-public-subnet-${count.index + 1}"
  }
}

//IGW
resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "jenkins-Internet-Gateway"
  }
}
//RT for Public subnet
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc.id
  }
  tags = {
    Name = "Jenkins-public-subnet-RT"
  }

}
//public RT Association to public subnets
resource "aws_route_table_association" "RT_public_subnet_association" {
  route_table_id = aws_route_table.public_RT.id
  count          = length(var.subnet_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)

}
#create ssh keypair, combination of public and private key
resource "tls_private_key" "jenkins-keys" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
#Save the private key to local file
resource "local_file" "jenkins-private-key" {
  filename = "${path.module}/id_rsa"
  content  = tls_private_key.jenkins-keys.private_key_pem
}
#Save the public key to local file
resource "local_file" "jenkins-public-key" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.jenkins-keys.public_key_openssh
}
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = tls_private_key.jenkins-keys.public_key_openssh
}
locals {
  instance = {
    jenkins-master = {
      tags   = ["jenkins-master"]
      ec2_az = "us-east-1a"
      script = "${path.module}/jenkins-master.sh"
    }
    jenkins-slave = {
      tags   = ["jenkins-slave"]
      ec2_az = "us-east-1a"
      script = "${path.module}/jenkins-slave.sh"
    }
  }
}
//Security Group
resource "aws_security_group" "tf_sg_allow_all" {
  name   = "allow_limited_ports"
  vpc_id = aws_vpc.custom_vpc.id # fix this also

  # SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_inbound_cidr_blocks
  }

  # Jenkins (8080)
  ingress {
    description = "Allow Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.sg_inbound_cidr_blocks
  }

  # Outbound (keep open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_outbound_cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}
#ec2-instance
resource "aws_instance" "terraform-instance" {
  for_each          = local.instance
  ami               = "ami-0b6c6ebed2801a5cb"
  availability_zone = each.value.ec2_az
  instance_type     = "t2.medium"
  key_name          = aws_key_pair.jenkins_key.key_name
  subnet_id = [
    for subnet in aws_subnet.public_subnet[*] :
    subnet.id
    if subnet.availability_zone == each.value.ec2_az
  ][0]
  vpc_security_group_ids      = [aws_security_group.tf_sg_allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name = each.key
  }
  user_data = file(each.key == "jenkins-slave" ? "${path.module}/jenkins-slave.sh" : "${path.module}/jenkins-master.sh")
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.vm_user
    private_key = tls_private_key.jenkins-keys.private_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      each.key == "jenkins-slave" ? "mkdir -p /home/${var.vm_user}/jenkins" : "echo 'Not an slave vm'"
    ]

  }
}
