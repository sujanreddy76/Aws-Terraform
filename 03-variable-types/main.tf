//Vpc
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
resource "aws_route_table" "tf_public_RT" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "tf_public_RT"
  }

}
//Public Subnet
resource "aws_subnet" "tf_public_subnet_1" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.vm_config.zone  //from object
  tags = {
    Name = "tf_public_subnet_1"
  }
}
//Subnet-RouteTable-association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.tf_public_subnet_1.id
  route_table_id = aws_route_table.tf_public_RT.id
}
//Security Group
resource "aws_security_group" "tf_sg" {
  name   = "allow_all"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks

  }
  tags = {
    Name = "allow_all"
  }

}

//ec2-instance
resource "aws_instance" "tf_ec2_1" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  availability_zone           = var.vm_config.zone //from object
  instance_type               = var.instance_type[var.environment]
  key_name                    = "sujanreddyNVKeypair"
  subnet_id                   = aws_subnet.tf_public_subnet_1.id
  security_groups             = [aws_security_group.tf_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "tf_ec2_1"
  }
  user_data = var.run_user_data ? file("${path.module}/user-data.sh") : null
}