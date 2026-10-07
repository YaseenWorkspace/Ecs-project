# Create an ECR repository. "foo" is its name inside Terraform
# (used in references, e.g. aws_ecr_repository.foo.repository_url).
resource "aws_ecr_repository" "foo" {

  # The repository's name in AWS. This becomes part of the image address, e.g.
  # 004406189017.dkr.ecr.eu-west-2.amazonaws.com/bar
  name = var.ecr_repository_name


  # Whether an image tag can be reused.
  # MUTABLE   = you can push a new image with the same tag (e.g. "latest") and it overwrites the old one.
  # IMMUTABLE = once a tag is used, it's locked. Pushing the same tag again is rejected.
  image_tag_mutability = "MUTABLE"

  # Security scanning settings.
  image_scanning_configuration {
    # Every time you push an image, AWS automatically scans it
    # for known security vulnerabilities in its packages.
    scan_on_push = true
  }
}