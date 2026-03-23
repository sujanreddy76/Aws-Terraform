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
variable "public_subnets_details" {
  type = list(object({
    subnet_name = string
    cidr_block  = string
    az          = string

  }))
  description = "list of public subnets details"
  default = [{
    subnet_name = "Public-subnet-1a"
    az          = "us-east-1a"
    cidr_block  = "10.0.1.0/24"


    },
    {
      subnet_name = "Public-subnet-1b"
      az          = "us-east-1b"
      cidr_block  = "10.0.2.0/24"


    }
  ]

}
variable "ec2_instances_details" {
  type = list(object({
    ec2_name         = string
    az               = string
    ec2_keypair_name = string

  }))
  description = "list of CIDR's of public subnets"
  default = [{
    ec2_name         = "Server-2"
    az               = "us-east-1b"
    ec2_keypair_name = "sujanreddyNVKeypair"

    },
    {
      ec2_name         = "Server-1"
      az               = "us-east-1a"
      ec2_keypair_name = "sujanreddyNVKeypair"
    }
  ]

}