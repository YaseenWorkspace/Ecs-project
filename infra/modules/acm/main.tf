# Look up the hosted zone created by hand (data = read an existing thing, don't create it).
# It's kept out of Terraform so its nameservers never change and the Cloudflare NS records stay valid.
data "aws_route53_zone" "main" {
  name = var.domain_name
}


# Request a free TLS certificate for the subdomain from AWS Certificate Manager.
# DNS validation = prove we own the domain by creating a DNS record ACM gives us.
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  # When the certificate is replaced, create the new one before deleting the old one,
  # so the ALB's HTTPS listener is never left without a certificate.
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.domain_name
  }
}


# Create the validation record(s) ACM asked for, inside our hosted zone.
# for_each loops over domain_validation_options (one entry per domain on the certificate).
resource "aws_route53_record" "validation" {
  for_each = {
    for option in aws_acm_certificate.main.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      type   = option.resource_record_type
      record = option.resource_record_value
    }
  }

  zone_id         = data.aws_route53_zone.main.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}


# Wait until ACM has checked the record and the certificate status is "Issued".
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}


# Point tm.yaseenali.co.uk at the ALB.
# An alias record is Route 53's version of a CNAME that also works at the top of a zone,
# and it follows the ALB's IP addresses automatically as they change.
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
