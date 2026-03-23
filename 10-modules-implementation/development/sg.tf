module "dev_sg_1" {
  source              = "../modules/security-group"
  vpc_name            = module.dev_vpc_1.vpc_name
  vpc_id              = module.dev_vpc_1.vpc_id
  ingress_allow_ports = var.ingress_allow_ports
  environment         = module.dev_vpc_1.environment

}