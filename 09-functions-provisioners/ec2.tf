//ec2-instance
resource "aws_instance" "public_server" {
  count                       = length(var.public_cidr_block)
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.public-subnet[*].id, count.index)

  vpc_security_group_ids      = [aws_security_group.allow_all.id]

  associate_public_ip_address = true

  tags = {
    Name        = "${var.vpc_name}-public-server-${count.index + 1}"
    Owner       = local.Owner
    environment = var.environment
  }
}