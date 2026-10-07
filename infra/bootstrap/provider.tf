# One-time setup for GitHub Actions: kept separate from the app infrastructure
# so `terraform destroy` in infra/ never removes the pipeline's access to AWS.
terraform {
  backend "s3" {
    bucket       = "terraform-state-yaseen"
    key          = "ecs-project/bootstrap.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-2"
}
