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
  description = "List of outbound CIDR ranges"
}
variable "public_subnets_details" {
  type = map(object({
    subnet_az         = string
    subnet_cidr_block = string
  }))
  description = "map of public subnet details"

}