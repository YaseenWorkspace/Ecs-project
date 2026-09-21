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
resource "aws_subnet" "ecs-subnet" {
    # The ID of the VPC.
    vpc_id     = aws_vpc.ecs-vpc.id
    # The value of an IP address or IP address range.
    cidr_block = "10.0.1.0/24"
}
# This resource creates an internet gateway for the VPC.
resource "internet_gateway" "ecs-igw" {
    # The ID of the VPC.
    vpc_id = aws_vpc.ecs-vpc.id
}