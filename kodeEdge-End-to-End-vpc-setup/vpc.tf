//VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "yt-vpc"
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
    Name = "YT-public-subnet-${count.index + 1}"
  }
}
//Private-Subnets
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  count  = length(var.subnet_availability_zones)
  //For Example: 10.0.0.0/16
  //cidrsubnet(10.0.0.0/16, 8, 0+1) => 10.0.1.0/24
  //cidrsubnet(10.0.0.0/16, 8, 1+1) => 10.0.2.0/24
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(var.subnet_availability_zones, count.index)
  tags = {
    Name = "YT-private-subnet-${count.index + 1}"
  }

}
//IGW
resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "YT-Internet-Gateway"
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
    Name = "public-subnet-RT"
  }

}
//public RT Association to public subnets
resource "aws_route_table_association" "RT_public_subnet_association" {
  route_table_id = aws_route_table.public_RT.id
  count          = length(var.subnet_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)

}
//Elastic IP
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_vpc]

}
//NAT gateway
resource "aws_nat_gateway" "yt_nat_gateway" {
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.igw_vpc]
  tags = {
    Name = "YT-NAT-Gateway"
  }

}
//RT for Private subnet
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.yt_nat_gateway.id
  }
  tags = {
    Name = "private-subnet-RT"
  }

}
//private RT Association to public subnets
resource "aws_route_table_association" "RT_private_subnet_association" {
  route_table_id = aws_route_table.private_RT.id
  count          = length(var.subnet_availability_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)

}
