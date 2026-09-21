# This module creates a VPC for ECS with the following resources:
resource "aws_vpc" "ecs-vpc" {
    # The value of an IP address or IP address range.
    cidr_block = "10.0.0.0/16"
}

# This resource creates a subnet in the VPC for ECS.
resource "aws_subnet" "ecs-subnet" {
"