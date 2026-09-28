module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  subnet_public_cidr_alternative = var.public_subnet_alternative 
  subnet_public_cidr  = var.public_subnet
  subnet_private_cidr = var.private_subnet
  
}

module "alb" {
  source = "./modules/alb"
  vpc_cidr = var.vpc_cidr
  subneta = module.vpc.vpc_public_subnets_id
  subnetb = module.vpc.vpc_public_subnets_second_id
  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source = "./modules/ecr"
  ecr_repository_name = var.ecr_repository_name  
}

module "ecs" {
  source = "./modules/ecs"
  private_subnet = module.vpc.vpc_private_subnets_id
  target_group_arn = module.alb.target_group_arn
}