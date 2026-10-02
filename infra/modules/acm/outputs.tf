output "zone_id" {
  description = "The ID of the Route 53 hosted zone, used for the record that points at the ALB"
  value       = data.aws_route53_zone.main.zone_id
}
