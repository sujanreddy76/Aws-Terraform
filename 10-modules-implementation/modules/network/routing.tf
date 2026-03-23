resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-RT"
    Owner       = local.Owner
    environment = var.environment
  }
}
resource "aws_route_table_association" "public_subnets_RT_association" {
  count = length(var.public_cidr_blocks)
  subnet_id = element(aws_subnet.public-subnet[*].id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.vpc_name}-private-RT"
    Owner       = local.Owner
    environment = var.environment
  }
}
resource "aws_route_table_association" "private_subnets_RT_association" {
  count = length(var.private_cidr_blocks)
  subnet_id = element(aws_subnet.private-subnet[*].id, count.index)
  route_table_id = aws_route_table.private-route-table.id
}
