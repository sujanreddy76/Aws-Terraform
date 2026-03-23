//string
variable "region" {
  type        = string
  description = "region where our resources will be created"
  default     = "us-east-1"
  validation {
    condition = contains(["us-east-1"], var.region)
    error_message = "region should be us-east-1 only"
  }
}
//bool
variable "run_user_data" {
  type        = bool
  description = "whether to run user data or not??"
  default     = false #true or false
}
//list(string)
variable "cidr_blocks" {
  type        = list(string)
  description = "list of cidr ranges"
  default     = ["0.0.0.0/0"]
}
variable "environment" {
  type    = string
  default = "dev"

}
//map(string)
variable "instance_type" {
  type        = map(string)
  description = "Type of VM"
  default = {
    "dev"  = "t2.nano"
    "prod" = "t2.micro"
  }
}
//==================== with objects ===================
//object
variable "vm_config" {
    type = object({
      name = string
      instance_type = string
      zone = string
      tags = map(string)
    })
    # default = {
    #   name = "object-vm"
    #   instance_type = "t2.nano"
    #   zone = "us-east-1a"
    #   tags = {
    #     "Name" = "object-vm"
    #     "Owner" = "sujan"
    #   }
    # }
}
//list(object)
variable "vm_list" {
    type = list(object({
      name = string
      instance_type = string
      zone = string
      tags = map(string)
    }))
  
}




