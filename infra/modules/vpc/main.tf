# This module creates a VPC for ECS with the following resources:
resource "aws_vpc" "ecs-vpc" {
    # The value of an IP address or IP address range.
    cidr_block = var.vpc_cidr
    tags = {
        # The name of the VPC.
        Name = "Project VPC"
    }
}
# This resource creates a subnet in the VPC for ECS.
resource "aws_subnet" "private-subnet" {
    # The ID of the VPC.
    vpc_id = aws_vpc.ecs-vpc.id
    # The value of an IP address or IP address range.
    cidr_block = var.subnet_private_cidr
}
resource "aws_subnet" "public-subnet" {
    # The ID of the VPC.
    vpc_id= aws_vpc.ecs-vpc.id
    # The value of an IP address or IP address range.
    cidr_block = var.subnet_public_cidr
    tags = {
        # The name of the subnet.
        Name = "Public Subnet"
    }
}
# This resource creates an internet gateway for the VPC.
resource "aws_internet_gateway" "igw" {
  # The ID of the VPC.
  vpc_id = aws_vpc.ecs-vpc.id

  tags = {
    Name = "main"
  }
}
# This resource creates a route table for the VPC.
resource "aws_route_table" "public_route_table" {
  # The ID of the VPC.
 vpc_id = aws_vpc.ecs-vpc.id
 # The route table is associated with the VPC. 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 # The tags for the route table.
 tags = {
   Name = "2nd Route Table"
 }
}
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_route_table.id
  # The route table allows ECS task to access the internet through the NAT gateway.
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_nat_gateway" "example" {
  vpc_id            = aws_vpc.ecs-vpc.id
  availability_mode = "regional"
}
