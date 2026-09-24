output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = aws_subnet.public-subnet[*].id
}

output "vpc_private_subnets" {
  description = "IDs of the VPC's private subnets"
  value       = aws_subnet.private-subnet[*].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.ecs-vpc.id
}

output "vpc_igw_id" {
  description = "ID of the VPC's internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "vpc_public_route_table_id" {
  description = "ID of the VPC's public route table"
  value       = aws_route_table.public_route_table.id
}

output "vpc_private_route_table_id" {
  description = "ID of the VPC's private route table"
  value       = aws_route_table.private_route_table.id
}

output "vpc_nat_gateway_id" {
  description = "ID of the VPC's NAT gateway"
  value       = aws_nat_gateway.example.id
}