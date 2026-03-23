provider "aws" {
  region = "us-east-1"

}

//data-source
data "aws_vpc" "vpc-from-data-source" {
  id = "vpc-03ad4f47374db09a9"

}
//igw
resource "aws_internet_gateway" "data-source-igw" {
  vpc_id = data.aws_vpc.vpc-from-data-source.id

  tags = {
    Name = "data-source-igw"
  }
}