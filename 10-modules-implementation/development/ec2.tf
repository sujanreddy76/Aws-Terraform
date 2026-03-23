module "dev_ec2" {
  source            = "../modules/ec2"
  environment       = module.dev_vpc_1.environment
  amis              = var.amis
  aws_region        = var.aws_region
  key_name          = var.key_name
  public_subnets    = module.dev_vpc_1.public_subnets
  private_subnets   = module.dev_vpc_1.private_subnets
  security_group_id = module.dev_sg_1.sg_id
  vpc_name          = module.dev_vpc_1.vpc_name

}