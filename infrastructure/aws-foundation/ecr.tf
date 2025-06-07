# ecr.tf
# This file defines the Elastic Container Registry (ECR) resources for the AI News Feed project
# ECR is used to store Docker container images that will be deployed to ECS

# Module: ECR Repository
# Creates an ECR repository with lifecycle policies and security scanning
module "ecr" {
  source = "./modules/ecr"

  # Repository naming follows the pattern: project-environment
  repository_name = "ai-news-feed-${var.environment}"

  # Pass environment and project information
  environment = var.environment
  project     = var.project_name

  # Additional tags specific to this module
  additional_tags = merge(
    var.tags,
    {
      Module      = "ecr"
      Description = "Container registry for AI News Feed application images"
    }
  )
}

# Outputs
# Export the repository URL for use in build scripts and ECS task definitions
output "ecr_repository_url" {
  description = "URL of the ECR repository for pushing and pulling images"
  value       = module.ecr.repository_url
}

# Export the repository ARN for IAM policies
output "ecr_repository_arn" {
  description = "ARN of the ECR repository for IAM policy configuration"
  value       = module.ecr.repository_arn
}

# Export the registry ID for cross-account access if needed
output "ecr_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr.registry_id
}
