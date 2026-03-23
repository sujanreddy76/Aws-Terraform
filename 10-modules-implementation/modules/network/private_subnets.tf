resource "aws_subnet" "private-subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_cidr_blocks, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Owner       = local.Owner
    environment = var.environment
  }
}