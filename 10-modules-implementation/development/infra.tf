module "dev_vpc_1" {
  source              = "../modules/network"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  environment         = var.environment
  public_cidr_blocks  = var.public_cidr_blocks
  private_cidr_blocks = var.private_cidr_blocks
  azs                 = var.azs
}