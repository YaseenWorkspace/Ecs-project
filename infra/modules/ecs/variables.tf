variable private_subnet {
    description = "The ID of the private subnet the ECS tasks run in"
    type = string 
}

variable target_group_arn {
    description = "The ARN of the ALB target group the ECS service registers its tasks in"
    type = string 
}
