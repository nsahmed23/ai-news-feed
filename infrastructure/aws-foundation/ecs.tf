# ecs.tf - ECS Cluster Configuration for AI News Feed

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-cluster"
      Component   = "ECS"
      Description = "ECS cluster for running containerized scrapers"
    }
  )
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }

  # Use FARGATE_SPOT for non-critical workloads to save costs
  # Can be overridden at task level
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = var.environment == "prod" ? 30 : 7 # Shorter retention for non-prod

  tags = merge(
    var.common_tags,
    {
      Name      = "${var.project_name}-${var.environment}-ecs-logs"
      Component = "Logging"
    }
  )
}

# Outputs
output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_log_group_name" {
  description = "The name of the ECS CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs.name
}
