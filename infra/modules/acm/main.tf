# Look up the hosted zone created by hand (data = read an existing thing, don't create it).
# It's kept out of Terraform so its nameservers never change and the Cloudflare NS records stay valid.
data "aws_route53_zone" "main" {
  name = var.domain_name
}
