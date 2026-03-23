resource "aws_route_table_association" "public-subnet-association" {
  count          = 3
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "private-subnet-association" {
  count          = 3
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-route-table.id
}