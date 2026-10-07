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
  certificate_arn = module.acm.certificate_arn
}

module "ecr" {
  source = "./modules/ecr"
  ecr_repository_name = var.ecr_repository_name  
}

module "ecs" {
  source = "./modules/ecs"
  private_subnet = module.vpc.vpc_private_subnets_id
  target_group_arn = module.alb.target_group_arn
  image_url = module.ecr.repository_url
  image_tag = var.image_tag
  alb_security_group_id = module.alb.security_group_id
  vpc_id = module.vpc.vpc_id

}
module "acm" {
  source      = "./modules/acm"
  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}
