output "aws_ecr_repository_id" {
  description = "The ID of the ECR repository (the repository's name)"
  value       = aws_ecr_repository.foo.id
}

output "repository_url" {
  description = "The URL of the ECR repository, used by the ECS task definition"
  value       = aws_ecr_repository.foo.repository_url
}