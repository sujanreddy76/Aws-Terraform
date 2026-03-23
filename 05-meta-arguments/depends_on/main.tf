//VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "tf_vpc"
  }
}
//IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}
//Public Route Table
resource "aws_route_table" "public_RT_tf" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id

  }
  tags = {
    Name = "public_RT_tf"
  }
}
//Public Subnet
resource "aws_subnet" "public-subnet-tf" {
  for_each          = var.public_subnets_details
  vpc_id            = aws_vpc.tf_vpc.id
  availability_zone = each.value.subnet_az
  cidr_block        = each.value.subnet_cidr_block

  tags = {
    Name = each.key
  }
}
//Public Subnet-Public RouteTable-association
resource "aws_route_table_association" "a" {
  for_each       = var.public_subnets_details
  subnet_id      = aws_subnet.public-subnet-tf[each.key].id
  route_table_id = aws_route_table.public_RT_tf.id
}
//Security Group
resource "aws_security_group" "tf_sg_allow_all" {
  name   = "allow_all"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_inbound_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_outbound_cidr_blocks

  }
  tags = {
    Name = var.sg_name
  }
  depends_on = [null_resource.delay_sg_creation]
}
//Simulate-Delay using null_resourc
resource "null_resource" "delay_sg_creation" {
  provisioner "local-exec" {
    command = "echo 'Simulating SG Creation delay.....' && sleep 90"

  }
}
#ec2-instance
resource "aws_instance" "terraform-instance" {
  ami               = "ami-0b6c6ebed2801a5cb"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"
  key_name          = "sujanreddyNVKeypair"
  subnet_id         = aws_subnet.public-subnet-tf["subnet-us-east-1a"].id

  vpc_security_group_ids      = [aws_security_group.tf_sg_allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = "server-1"
    Env        = "Prod"
    Owner      = "sujan"
    CostCenter = "ABCD"
  }
  #   depends_on = [ aws_security_group.tf_sg_allow_all ]
}



