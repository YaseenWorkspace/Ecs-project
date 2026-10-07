# Tell AWS to trust login tokens issued by GitHub Actions.
# This replaces stored AWS access keys each pipeline run gets short-lived credentials instead.
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


# AWS managed policies for each service the pipeline builds or deploys.
resource "aws_iam_role_policy_attachment" "github_actions" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",                  # VPC, subnets, NAT, security groups, ALB
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",                 # ECS cluster, service, task definition
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", # push images, manage the ECR repo
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",              # DNS records
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess",      # TLS certificate
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",             # ECS log group
  ])

  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}


# Narrow extra permissions: read/write this project's state in S3, and manage
# only the ECS task execution role (not every IAM role in the account).
resource "aws_iam_role_policy" "github_actions_extra" {
  name = "terraform-state-and-ecs-role"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::terraform-state-yaseen"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::terraform-state-yaseen/ecs-project/*"
      },
      {
        Effect   = "Allow"
        Action   = ["iam:*Role*", "iam:PassRole"]
        Resource = "arn:aws:iam::004406189017:role/ecs-task-execution-role"
      }
    ]
  })
}
