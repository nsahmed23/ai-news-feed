# Input variables for ECR repository module

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "ai-news-feed-development"
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of images to keep in the repository"
  type        = number
  default     = 10
}

variable "untagged_days" {
  description = "Number of days after which to mark images as untagged if not latest"
  type        = number
  default     = 7
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "development"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "ai-news-feed"
}

variable "additional_tags" {
  description = "Additional tags to apply to the ECR repository"
  type        = map(string)
  default     = {}
}