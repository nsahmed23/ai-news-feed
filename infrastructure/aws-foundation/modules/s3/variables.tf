# Variables for S3 module

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block all public access to the bucket"
  type        = bool
  default     = true
}

variable "website_configuration" {
  description = "Website hosting configuration"
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}

variable "cors_rules" {
  description = "CORS rules for the bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket"
  type = list(object({
    id      = string
    enabled = bool

    prefix = optional(string, "")

    transitions = optional(list(object({
      days          = number
      storage_class = string
    })))

    expiration = optional(object({
      days = number
    }))

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))

    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
  }))
  default = []
}

variable "logging_configuration" {
  description = "Logging configuration for the bucket"
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = null
}

variable "enable_intelligent_tiering" {
  description = "Enable S3 Intelligent-Tiering for automatic cost optimization"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}