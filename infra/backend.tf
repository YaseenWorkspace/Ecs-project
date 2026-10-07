# Store Terraform's state in S3 instead of on this laptop, so the
# GitHub Actions pipeline and local runs share the same state.
terraform {
  backend "s3" {
    bucket = "terraform-state-yaseen"
    key    = "ecs-project/terraform.tfstate"
    region = "eu-west-2"

    # Encrypt the state file at rest (it can contain sensitive values).
    encrypt = true

    # Lock the state with a lock file in S3, so two runs can't change it at the same time.
    use_lockfile = true
  }
}
