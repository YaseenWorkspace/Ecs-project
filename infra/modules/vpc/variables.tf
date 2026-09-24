variable subnet_public_cidr {
  description = "The CIDR block for the public subnet."
  type        = string
}

variable subnet_private_cidr {
  description = "The CIDR block for the private subnet."
  type        = string
}

variable vpc_cidr {
  description = "The CIDR block for the VPC."
  type        = string
}