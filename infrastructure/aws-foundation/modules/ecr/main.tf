# ECR Repository Configuration

# Create the ECR repository with specified settings
resource "aws_ecr_repository" "this" {
  name = var.repository_name

  # Enable image tag immutability to prevent image tags from being overwritten
  # This ensures that once an image is pushed with a specific tag, that tag cannot be reused
  image_tag_mutability = var.image_tag_mutability

  # Enable image scanning on push for security vulnerability detection
  # This automatically scans images for known vulnerabilities when they are pushed to the repository
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Apply tags for resource identification and cost tracking
  tags = merge(
    {
      Name        = var.repository_name
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )
}

# Lifecycle policy to manage image retention and control storage costs
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  # Policy rules with unique tag sets to avoid validation errors
  policy = jsonencode({
    rules = [
      {
        # Rule 1: Remove untagged images after 1 day
        # This helps clean up failed or incomplete pushes quickly
        rulePriority = 1
        description  = "Remove untagged images after 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        # Rule 2: Keep only the last 10 version-tagged images
        # For semantic versioning (v1.0.0, v2.1.0, etc.)
        rulePriority = 2
        description  = "Keep only the last ${var.max_image_count} version-tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.max_image_count
        }
        action = {
          type = "expire"
        }
      },
      {
        # Rule 3: Keep only the last 5 dev/staging images
        # For development and staging environments
        rulePriority = 3
        description  = "Keep only the last 5 dev/staging images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["dev", "staging"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      },
      {
        # Rule 4: Keep only the last 3 production images
        # For production environment (more conservative retention)
        rulePriority = 4
        description  = "Keep only the last 3 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        # Rule 5: Always keep the latest tag
        # This ensures the most recent stable image is always available
        rulePriority = 5
        description  = "Always keep the latest tag"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["latest"]
          countType     = "imageCountMoreThan"
          countNumber   = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        # Rule 6: Remove old timestamp-tagged images after 30 days
        # For images tagged with timestamps (20231206123456)
        rulePriority = 6
        description  = "Remove timestamp-tagged images older than 30 days"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["2"] # Assumes timestamps start with year 2xxx
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Repository policy to control access (optional, can be extended as needed)
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name

  # Basic policy allowing AWS account to pull images
  # This can be extended to allow cross-account access or specific IAM roles
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "AllowPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}
