output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.vpc-terraform.id
  
}
output "subnet_id" {
    description = "The ID of the subnet"
    value = aws_subnet.public-subnet-terraform.id
  
}
output "instance_external_ip" {
    description = "The external ip of the GCE instance"
    value = aws_instance.terraform-instance.public_ip
}