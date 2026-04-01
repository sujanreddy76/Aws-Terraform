variable "subnet_availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a"]
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
  description = "List of outbound CIDR ranges"
}
variable "vm_user" {
  type        = string
  description = "name of the vm user to connect to ubuntu vm"

}
