

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  subnet_public_cidr  = var.public_subnet
  subnet_private_cidr = var.private_subnet
}
