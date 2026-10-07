output "private_subnet_id" {
  description = "The ID of the private subnet the ECS tasks run in"
  value       = var.private_subnet
}

output "vpc" {
  description = "The ID of the VPC the ECS tasks run in"
  value       = var.vpc_id
}