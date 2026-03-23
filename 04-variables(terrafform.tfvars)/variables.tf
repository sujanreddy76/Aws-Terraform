variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
variable "vpc_cidr" {
  type        = string
  description = "Vpc CIDR range"
}
variable "igw_name" {
  type        = string
  description = "Name of the Internet Gateway"

}
variable "RT_name" {
  type        = string
  description = "Name of the Route Table"

}
variable "pub_RT_route1_cidr" {
  type        = string
  description = "Destination CIDR for IGW to internet"
}
variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}
variable "subnet_az" {
  type        = string
  description = "Availability zone where subnet will be created"
}
variable "subnet_cidr_block" {
  type        = string
  description = "Subnet CIDR range"

}
variable "sg_name" {
  type        = string
  description = "Name of the security group"
}
variable "sg_inbound_cidr_blocks" {
  type        = list(string)
  description = "List of inbound CIDR ranges"
}
variable "sg_outbound_cidr_blocks" {
  type        = list(string)
  description = "List of inbound CIDR ranges"
}
variable "ec2-name" {
  type        = string
  description = "Name of the ec2-instance"

}
variable "ec2_az" {
  type        = string
  description = "Availability zone where ec2-instance will be created"

}
variable "ec2_keypair_name" {
  type        = string
  description = ""

}
