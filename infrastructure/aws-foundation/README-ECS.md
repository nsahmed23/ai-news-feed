# ECS Cluster Setup (AUT-004)

## Overview
This module sets up the ECS (Elastic Container Service) infrastructure for running containerized web scrapers using Playwright on Fargate.

## Components Created

### 1. ECS Cluster (`ecs.tf`)
- **Cluster Name**: `ai-news-feed-{environment}-cluster`
- **Container Insights**: Enabled for monitoring
- **Capacity Providers**: 
  - FARGATE (default)
  - FARGATE_SPOT (for cost optimization)

### 2. IAM Roles (`iam_ecs.tf`)
- **Task Execution Role**: Used by ECS to pull images and write logs
  - Permissions: ECR access, CloudWatch Logs
- **Task Role**: Used by applications running in containers
  - Permissions: S3, DynamoDB, Secrets Manager

### 3. CloudWatch Resources (`cloudwatch.tf`)
- **Log Groups**:
  - `/ecs/ai-news-feed-{environment}` - ECS cluster logs
  - `/aws/application/ai-news-feed-{environment}` - Application logs
  - `/aws/scrapers/ai-news-feed-{environment}` - Scraper-specific logs
- **Dashboard**: Basic monitoring dashboard for cluster metrics
- **Alarms**: CPU utilization alarm (threshold: 80%)

### 4. Log Retention
- Production: 30 days for ECS logs, 14 days for scraper logs
- Non-Production: 7 days for ECS logs, 3 days for scraper logs

## Cost Optimization Features

1. **FARGATE_SPOT Support**: Configured to use spot instances for non-critical workloads
2. **Short Log Retention**: Reduced retention for non-production environments
3. **Single NAT Gateway**: Already configured in VPC (saving $45/month)

## Outputs Available

- `ecs_cluster_id` - Cluster ID for task definitions
- `ecs_cluster_arn` - Cluster ARN for IAM policies
- `ecs_cluster_name` - Cluster name for deployments
- `ecs_log_group_name` - Log group for container logs
- `ecs_task_execution_role_arn` - Role ARN for task definitions
- `ecs_task_role_arn` - Role ARN for application permissions

## Next Steps

1. **ECR Repository (AUT-006)**: Create container registry for Docker images
2. **Task Definitions**: Define Playwright scraper containers
3. **Services**: Configure ECS services for each scraper

## Usage

```bash
# Plan the changes
terraform plan

# Apply the ECS cluster setup
terraform apply

# Verify cluster creation
aws ecs describe-clusters --clusters ai-news-feed-development-cluster
```

## Monitoring

Access the CloudWatch dashboard:
- URL will be output after apply as `cloudwatch_dashboard_url`
- Metrics: CPU/Memory utilization
- Logs: Recent ECS task logs

## Security Considerations

- Task execution role has minimal permissions (ECR pull, log write)
- Task role permissions scoped to specific S3 buckets and DynamoDB tables
- Secrets Manager access limited to project-specific paths
