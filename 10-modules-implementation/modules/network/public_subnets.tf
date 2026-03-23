resource "aws_subnet" "public-subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cidr_blocks, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Owner       = local.Owner
    environment = var.environment
  }
}