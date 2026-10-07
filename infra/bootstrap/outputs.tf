output "github_actions_role_arn" {
  description = "The ARN of the role GitHub Actions assumes, used in the workflows' role-to-assume"
  value       = aws_iam_role.github_actions.arn
}
