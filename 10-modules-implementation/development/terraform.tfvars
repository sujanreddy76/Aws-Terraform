aws_region          = "us-east-1"
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "dev-vpc-1"
environment         = "dev"
public_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
ingress_allow_ports = ["80", "443", "22"]
amis = {
  us-east-1 = "ami-0b6c6ebed2801a5cb"
  us-east-2 = "ami-0198cdf7458a7a932"
}
key_name = "sujanreddyNVKeypair"