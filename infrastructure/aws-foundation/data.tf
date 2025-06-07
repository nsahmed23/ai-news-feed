# data.tf - Data Sources for AI News Feed Infrastructure

# Current AWS Account ID
data "aws_caller_identity" "current" {}

# Available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
