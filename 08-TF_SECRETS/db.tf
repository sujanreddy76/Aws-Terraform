data "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-secret"
}
data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id

}
resource "aws_db_subnet_group" "prod_subnet_group" {
  name = "prod-db-subnet-group"
  subnet_ids = [
    aws_subnet.subnet1-public.id,
    aws_subnet.subnet2-public.id,
    aws_subnet.subnet3-public.id
  ]
  tags = {
    Name = "Production DB Subnet Group"
  }

}
resource "aws_db_instance" "prod_db_instance" {
  identifier           = "proddb"
  allocated_storage    = 20
  db_name              = "proddb"
  engine               = "mysql"
  engine_version       = "8.4.7"
  instance_class       = "db.t3.medium"
  storage_type         = "gp2"
  username             = "adminuser"
  password             = data.aws_secretsmanager_secret_version.db_secret_version.secret_string
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.prod_subnet_group.id
}