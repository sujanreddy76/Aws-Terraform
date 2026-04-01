provider "aws" {
  region = "us-east-1"
}

//vpc
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-terraform"
  }
}
//igw
resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id
  tags = {
    Name = "igw-terraform"
  }

}
//Public Subnet
resource "aws_subnet" "public-subnet-terraform" {
  vpc_id     = aws_vpc.vpc-terraform.id
  availability_zone  = "us-east-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-terraform"
  }
}
//Route Table
resource "aws_route_table" "public-rt-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terraform.id
  }

  tags = {
    Name    = "public-rt-terraform"
    Service = "Terraform"
  }
}
//Subnet-RouteTable-association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet-terraform.id
  route_table_id = aws_route_table.public-rt-terraform.id
}
//Security group
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-terraform.id
  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    //In AWS Security Groups: protocol = "-1" means: Allow ALL protocols
    //When protocol = -1 Then from_port and to_port are ignored by AWS. Meaning: Allow all inbound traffic from anywhere on all ports and all protocols.
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}
#create ssh keypair, combination of public and private key
resource "tls_private_key" "jenkins-keys" {
  algorithm = "RSA"
  rsa_bits = 4096
  
}
#Save the private key to local file
resource "local_file" "jenkins-private-key" {
    filename = "${path.module}/id_rsa"
    content = tls_private_key.jenkins-keys.private_key_pem
}
#Save the public key to local file
resource "local_file" "jenkins-public-key" {
    filename = "${path.module}/id_rsa.pub"
    content = tls_private_key.jenkins-keys.public_key_openssh 
}
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"
  public_key = tls_private_key.jenkins-keys.public_key_openssh
}


#ec2-instance
resource "aws_instance" "terraform-instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.jenkins_key.key_name
  subnet_id                   = aws_subnet.public-subnet-terraform.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "sai"
    CostCenter = "ABCD"
  }
}

