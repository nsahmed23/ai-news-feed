# CloudTrail for API audit logging

# S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail" {
  bucket = "ai-news-feed-${var.environment}-cloudtrail-${random_string.bucket_suffix.result}"

  tags = merge(var.tags, {
    Name    = "ai-news-feed-${var.environment}-cloudtrail"
    Purpose = "CloudTrail audit logs"
  })
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Lifecycle policy to manage costs
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    filter {}  # Apply to all objects

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = 365 # Keep logs for 1 year for compliance
    }
  }
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name           = "${var.project_name}-${var.environment}-trail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  # Log all regions
  is_multi_region_trail = true

  # Enable log validation
  enable_log_file_validation = true

  # Log global services like IAM
  include_global_service_events = true

  # Capture read and write events
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    # Optional: Log all S3 object operations
    data_resource {
      type = "AWS::S3::Object"
      values = [
        "${module.scraped_data_bucket.bucket_arn}/*",
        "${module.static_assets_bucket.bucket_arn}/*"
      ]
    }
  }

  # CloudWatch Logs integration (optional but recommended)
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch.arn

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-trail"
    Purpose = "API audit logging"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

# CloudWatch Log Group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.project_name}-${var.environment}"
  retention_in_days = 30 # Keep CloudWatch logs for 30 days

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-cloudtrail-logs"
    Purpose = "CloudTrail logs in CloudWatch"
  })
}

# IAM Role for CloudTrail to write to CloudWatch
resource "aws_iam_role" "cloudtrail_cloudwatch" {
  name = "${var.project_name}-${var.environment}-cloudtrail-cloudwatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for CloudTrail to write to CloudWatch
resource "aws_iam_role_policy" "cloudtrail_cloudwatch" {
  name = "cloudtrail-cloudwatch-logs"
  role = aws_iam_role.cloudtrail_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}

# Outputs
output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail.id
}