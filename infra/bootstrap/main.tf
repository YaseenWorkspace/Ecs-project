# Tell AWS to trust login tokens issued by GitHub Actions.
# This replaces stored AWS access keys: each pipeline run gets short-lived credentials instead.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}


# The role GitHub Actions takes on. The trust policy says who may use it:
# only workflows in YaseenWorkspace/Ecs-project, logging in through the OIDC provider above.
resource "aws_iam_role" "github_actions" {
  name = "github-actions-ecs-project"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          # The token must be meant for AWS STS.
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          # The token must come from this repository (any branch, tag or manual run).
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:YaseenWorkspace/Ecs-project:*"
          }
        }
      }
    ]
  })
}
