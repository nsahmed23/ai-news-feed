# Output values for the ECR repository module

# The full Amazon Resource Name (ARN) of the repository
# Use this when you need to reference the repository in IAM policies or other AWS resources
output "repository_arn" {
  description = "Full ARN of the ECR repository"
  value       = aws_ecr_repository.this.arn
}

# The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)
# Use this as the base URL when pushing or pulling Docker images
output "repository_url" {
  description = "URL of the ECR repository for docker push/pull operations"
  value       = aws_ecr_repository.this.repository_url
}

# The registry ID where the repository was created
# This is typically your AWS account ID
output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = aws_ecr_repository.this.registry_id
}

# The name of the repository
# Useful for referencing in scripts or other Terraform resources
output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

# Repository policy ARN if needed for cross-account access configuration
output "repository_policy_id" {
  description = "The policy document ID of the ECR repository policy"
  value       = aws_ecr_repository_policy.this.id
}

# Lifecycle policy details
output "lifecycle_policy_id" {
  description = "The registry ID and repository name of the lifecycle policy"
  value       = aws_ecr_lifecycle_policy.this.id
}

# Tags applied to the repository
output "repository_tags" {
  description = "Tags applied to the ECR repository"
  value       = aws_ecr_repository.this.tags
}

# Image scanning configuration status
output "scan_on_push_enabled" {
  description = "Whether image scanning on push is enabled"
  value       = aws_ecr_repository.this.image_scanning_configuration[0].scan_on_push
}

# Image tag mutability setting
output "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  value       = aws_ecr_repository.this.image_tag_mutability
}