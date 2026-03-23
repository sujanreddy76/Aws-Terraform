//vpc
data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0cdcf6f52fc5ae43f"
}
//Subnet
data "aws_subnet" "Terraform_Public_Subnet1-testing" {

  id = "subnet-04ec616f10073d5f9"
}
//SG
data "aws_security_group" "allow_all" {
  id = "sg-09d3d9dd3042066d4"

}