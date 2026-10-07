variable "subneta" {
  description = "The subnet for my main public subnet"
  type        = string
}


variable "subnetb" {
  description = "The subnet for my public alternative subnet"
  type        = string
}


variable "vpc_id" {
  description = "The ID of my VPC for the ALB security group"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate used by the HTTPS listener"
  type        = string
}
