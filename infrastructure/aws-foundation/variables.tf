# Input Variables

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for cost savings (not HA)"
  type        = bool
  default     = true
}

variable "created_date" {
  description = "Date when the infrastructure was created"
  type        = string
  default     = "2024-12-04"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "ai-updates-tracker"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "ai-updates-tracker"
    ManagedBy   = "Terraform"
    Environment = "development"
  }
}

variable "create_rds_sg" {
  description = "Whether to create RDS security group (set to true when RDS is needed)"
  type        = bool
  default     = false
}

variable "create_terraform_state_bucket" {
  description = "Whether to create S3 bucket for Terraform remote state storage"
  type        = bool
  default     = false # Set to true if you want to use remote state
}
