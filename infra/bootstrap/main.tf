# Tell AWS to trust login tokens issued by GitHub Actions.
# This replaces stored AWS access keys: each pipeline run gets short-lived credentials instead.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}
