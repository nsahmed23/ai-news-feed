# S3 Bucket Module

# Create the S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = var.tags
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Using S3-managed keys for cost efficiency
    }
    bucket_key_enabled = true # Reduces encryption costs
  }
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# Public access block - only create if block_public_access is true
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.block_public_access ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy for public read (if needed for static hosting)
resource "aws_s3_bucket_policy" "public_read" {
  count = !var.block_public_access && var.website_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  # Ensure public access block is removed before applying policy
  depends_on = [aws_s3_bucket_public_access_block.this]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}

# Website configuration
resource "aws_s3_bucket_website_configuration" "this" {
  count = var.website_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.website_configuration.index_document
  }

  error_document {
    key = var.website_configuration.error_document
  }
}

# CORS configuration
resource "aws_s3_bucket_cors_configuration" "this" {
  count = length(var.cors_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      # AWS requires either filter or prefix (we'll use filter with empty prefix for all objects)
      filter {
        prefix = lookup(rule.value, "prefix", "")
      }

      # Transitions to different storage classes
      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", null) != null ? rule.value.transitions : []
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      # Expiration rules
      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", null) != null ? [rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }

      # Cleanup incomplete multipart uploads
      dynamic "abort_incomplete_multipart_upload" {
        for_each = lookup(rule.value, "abort_incomplete_multipart_upload", null) != null ? [rule.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }

      # Non-current version expiration
      dynamic "noncurrent_version_expiration" {
        for_each = lookup(rule.value, "noncurrent_version_expiration", null) != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }
    }
  }
}

# Bucket logging
resource "aws_s3_bucket_logging" "this" {
  count = var.logging_configuration != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging_configuration.target_bucket
  target_prefix = var.logging_configuration.target_prefix
}

# Intelligent tiering configuration for automatic cost optimization
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count = var.enable_intelligent_tiering ? 1 : 0

  bucket = aws_s3_bucket.this.id
  name   = "${var.bucket_name}-intelligent-tiering"

  # Archive configurations for even more savings
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}