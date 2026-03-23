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
}
#ec2-instance
resource "aws_instance" "terraform-instance" {
  for_each = {
    for ec2 in var.ec2_instances_details :
    ec2.ec2_name => ec2
  }
  ami               = "ami-0b6c6ebed2801a5cb"
  availability_zone = each.value.ec2_az
  instance_type     = "t2.micro"
  key_name          = each.value.ec2_keypair_name
  subnet_id = [
    for subnet in aws_subnet.public-subnet-tf :
    subnet.id
    if subnet.availability_zone == each.value.ec2_az
  ][0]
  vpc_security_group_ids      = [aws_security_group.tf_sg_allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = each.value.ec2_name
    Env        = "Prod"
    Owner      = "sujan"
    CostCenter = "ABCD"
  }
}


