variable "domain_name" {
  description = "The subdomain the certificate is for, e.g. tm.yaseenali.co.uk"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB the subdomain points to"
  type        = string
}

variable "alb_zone_id" {
  description = "The hosted zone ID of the ALB the subdomain points to"
  type        = string
}
