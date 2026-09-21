# This module creates a VPC for ECS with the following resources:
resource "aws_vpc" "ecs-vpc" {
    # The value of an IP address or IP address range.
    cidr_block = "10.0.0.0/16"
    tags = {
        # The name of the VPC.
        Name = "Project VPC"
    }
}
# This resource creates a subnet in the VPC for ECS.
resource "aws_subnet" "private-subnet" {
    # The ID of the VPC.
    vpc_id     = aws_vpc.ecs-vpc.id
    # The value of an IP address or IP address range.
    cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "public-subnet" {
    # The ID of the VPC.
    vpc_id     = aws_vpc.ecs-vpc.id
    # The value of an IP address or IP address range.
    cidr_block = "10.0.2.0/24"
    tags = {
        # The name of the subnet.
        Name = "Public Subnet"
    }
}
# This resource creates an internet gateway for the VPC.
resource "aws_internet_gateway" "ecs-igw" {
    # The ID of the VPC.
    vpc_id = aws_vpc.ecs-vpc.id
    # The tags for the internet gateway.
    tags = {
        Name = "Project VPC IG"
    }
}

# This resource creates a route table for the VPC.
resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 # The route table is associated with the VPC.
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 # The tags for the route table.
 tags = {
   Name = "2nd Route Table"
 }
}