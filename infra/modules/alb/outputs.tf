output aws_subnet_id {
    description = "The ID of the main subnet"
    value = aws_lb.alb.id
}

output "target_group_arn" {
    description = "The ARN of the target group, used by the ECS service"
    value       = aws_lb_target_group.app.arn
}

output security_group_id {
    description = "The ID of the ALB's security group, used to allow ALB traffic into the ECS tasks"
    value = aws_security_group.allow_tls.id
}