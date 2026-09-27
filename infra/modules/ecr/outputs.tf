output aws_ecr_repository_id {
    description = "The ID of the ECR repository (the repository's name)"
    value = aws_ecr_repository.foo.id
}