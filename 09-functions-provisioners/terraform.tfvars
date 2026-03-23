aws_region = "us-east-1"

vpc_cidr = "172.18.0.0/16"
vpc_name = "devsecops-vpc"
key_name = "sujanreddyNVKeypair"

public_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24"]
azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
environment        = "prod"
ingress_allow      = ["80", "443", "22"]
amis = {
  us-east-1 = "ami-0b6c6ebed2801a5cb"
  us-east-2 = "ami-0198cdf7458a7a932"
}
