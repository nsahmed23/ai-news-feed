# S3 Buckets for AI News Feed

# Random suffix for unique bucket names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 1. Scraped Data Bucket - Store JSON data from web scrapers
module "scraped_data_bucket" {
  source = "./modules/s3"

  bucket_name = "ai-news-feed-${var.environment}-scraped-data-${random_string.bucket_suffix.result}"
  environment = var.environment

  # Enable versioning for data recovery
  versioning_enabled = true

  # Lifecycle rules for cost optimization
  lifecycle_rules = [{
    id      = "transition-old-data"
    enabled = true

    transitions = [
      {
        days          = 30
        storage_class = "STANDARD_IA" # Infrequent Access after 30 days
      },
      {
        days          = 90
        storage_class = "GLACIER_IR" # Glacier Instant Retrieval after 90 days
      }
    ]

    expiration = {
      days = 365 # Delete after 1 year
    }
  }]

  # CORS configuration for API access
  cors_rules = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"] # Will restrict this in production
    max_age_seconds = 3000
  }]

  tags = merge(var.tags, {
    Name    = "ai-news-feed-${var.environment}-scraped-data"
    Purpose = "Store JSON data from web scrapers"
  })
}

# 2. Static Assets Bucket - Frontend files, images, etc.
module "static_assets_bucket" {
  source = "./modules/s3"

  bucket_name = "ai-news-feed-${var.environment}-static-assets-${random_string.bucket_suffix.result}"
  environment = var.environment

  # Versioning not needed for static assets
  versioning_enabled = false

  # Public read access for static website hosting
  block_public_access = false

  # Website configuration
  website_configuration = {
    index_document = "index.html"
    error_document = "error.html"
  }

  # CORS for frontend assets
  cors_rules = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }]

  # Lifecycle rules for old versions and incomplete uploads
  lifecycle_rules = [{
    id      = "cleanup-incomplete-uploads"
    enabled = true

    abort_incomplete_multipart_upload = {
      days_after_initiation = 7
    }
  }]

  tags = merge(var.tags, {
    Name    = "ai-news-feed-${var.environment}-static-assets"
    Purpose = "Host frontend static files"
  })
}

# 3. Terraform State Bucket (Optional - for remote state management)
module "terraform_state_bucket" {
  source = "./modules/s3"
  count  = var.create_terraform_state_bucket ? 1 : 0

  bucket_name = "ai-news-feed-terraform-state-${random_string.bucket_suffix.result}"
  environment = "shared" # Shared across environments

  # Critical: Enable versioning for state file history
  versioning_enabled = true

  # No public access for state files
  block_public_access = true

  # Lifecycle rule to keep multiple versions but clean up old ones
  lifecycle_rules = [{
    id      = "cleanup-old-versions"
    enabled = true

    noncurrent_version_expiration = {
      noncurrent_days = 90 # Keep old versions for 90 days
    }
  }]

  # Enable bucket logging for audit trail
  logging_configuration = {
    target_bucket = module.static_assets_bucket.bucket_id
    target_prefix = "terraform-state-logs/"
  }

  tags = merge(var.tags, {
    Name     = "ai-news-feed-terraform-state"
    Purpose  = "Terraform remote state storage"
    Critical = "true"
  })
}

# DynamoDB table for Terraform state locking (if using remote state)
resource "aws_dynamodb_table" "terraform_locks" {
  count        = var.create_terraform_state_bucket ? 1 : 0
  name         = "ai-news-feed-terraform-locks"
  billing_mode = "PAY_PER_REQUEST" # No need to provision capacity
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    Name    = "ai-news-feed-terraform-locks"
    Purpose = "Terraform state locking"
  })
}

# Task role policy for S3 access - Updated with least privilege
# Note: Removed DeleteObject permission for better security
resource "aws_iam_role_policy" "ecs_task_s3_buckets_access" {
  name = "ecs-task-s3-buckets-access"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadWriteScrapedData"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
          # Removed s3:DeleteObject for security
        ]
        Resource = [
          module.scraped_data_bucket.bucket_arn,
          "${module.scraped_data_bucket.bucket_arn}/*"
        ]
      },
      {
        Sid    = "ReadOnlyStaticAssets"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.static_assets_bucket.bucket_arn,
          "${module.static_assets_bucket.bucket_arn}/*"
        ]
      }
    ]
  })
}