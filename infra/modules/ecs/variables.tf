variable private_subnet {
    description = "The ID of the private subnet the ECS tasks run in"
    type = string 
}

variable target_group_arn {
    description = "The ARN of the ALB target group the ECS service registers its tasks in"
    type = string 
}
variable image_url {
    description = "The URL of the ECR repository holding the app's Docker image"
    type = string
}

variable image_tag {
    description = "The tag of the Docker image to run (e.g. latest or a commit SHA)"
    type = string
}

variable vpc_id {
    description = "The ID of the VPC the ECS task security group is created in"
    type = string
}

variable alb_security_group_id {
    description = "The ID of the ALB's security group, the only source allowed to reach the tasks"
    type = string
}
