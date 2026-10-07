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
output security_group_egress_id {
    description = "The ID of the ALB security group's outbound (egress) rule"
    value = aws_security_group_rule.outbound.id
}

output "alb_dns_name" {
    description = "The DNS name of the load balancer, used by the Route 53 alias record"
    value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
    description = "The hosted zone ID of the load balancer, used by the Route 53 alias record"
    value       = aws_lb.alb.zone_id
}
