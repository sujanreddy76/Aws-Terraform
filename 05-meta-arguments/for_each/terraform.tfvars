sg_name                 = "tf_sg_allow_all"
sg_inbound_cidr_blocks  = ["0.0.0.0/0"]
sg_outbound_cidr_blocks = ["0.0.0.0/0"]
public_subnets_details = {
    "subnet-us-east-1a" = {
      subnet_az         = "us-east-1a"
      subnet_cidr_block = "10.0.1.0/24"

    },
    "subnet-us-east-1b" = {
      subnet_az         = "us-east-1b"
      subnet_cidr_block = "10.0.2.0/24"
    } 
}
ec2_instances_details = [{
    ec2_name         = "Server-2"
    ec2_az           = "us-east-1b"
    ec2_keypair_name = "sujanreddyNVKeypair"

    },
    {
      ec2_name         = "Server-1"
      ec2_az           = "us-east-1a"
      ec2_keypair_name = "sujanreddyNVKeypair"
    }
  ]

