//VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
//IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = var.igw_name
  }
}
//Public Route Table
resource "aws_route_table" "public_RT_tf" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = var.pub_RT_route1_cidr
    gateway_id = aws_internet_gateway.tf_igw.id

  }
  tags = {
    Name = var.RT_name
  }

}
//Public Subnet
resource "aws_subnet" "public-subnet-tf" {
  vpc_id            = aws_vpc.tf_vpc.id
  availability_zone = var.subnet_az
  cidr_block        = var.subnet_cidr_block

  tags = {
    Name = var.subnet_name
  }
}
//Public Subnet-Public RouteTable-association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet-tf.id
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

}
#ec2-instance
resource "aws_instance" "terraform-instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  availability_zone           = var.ec2_az
  instance_type               = "t2.micro"
  key_name                    = var.ec2_keypair_name
  subnet_id                   = aws_subnet.public-subnet-tf.id
  vpc_security_group_ids      = [aws_security_group.tf_sg_allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = var.ec2-name
    Env        = "Prod"
    Owner      = "sai"
    CostCenter = "ABCD"
  }
}


