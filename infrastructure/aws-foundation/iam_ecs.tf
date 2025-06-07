# iam_ecs.tf - IAM Roles for ECS Tasks

# ECS Task Execution Role (used by ECS to pull images and write logs)
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-ecs-task-execution"
      Component   = "IAM"
      Description = "Role for ECS task execution"
    }
  )
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional policy for CloudWatch Logs
resource "aws_iam_role_policy" "ecs_task_execution_cloudwatch" {
  name = "ecs-task-execution-cloudwatch"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecs.arn}:*"
      }
    ]
  })
}

# ECS Task Role (used by the application inside the container)
resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-${var.environment}-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-ecs-task"
      Component   = "IAM"
      Description = "Role for ECS task applications"
    }
  )
}

# Task role policy for S3 access - Moved to s3.tf where actual buckets are created
# The policy in s3.tf references the actual bucket resources for better maintainability

# Task role policy for DynamoDB access (if using for state/tracking)
# Updated with least privilege - only specific actions needed
resource "aws_iam_role_policy" "ecs_task_dynamodb_access" {
  name = "ecs-task-dynamodb-access"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
          # Removed DeleteItem and Scan for security
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.project_name}-${var.environment}-*"
      }
    ]
  })
}

# Task role policy for Secrets Manager (for API keys, etc.)
# Updated to be more specific
resource "aws_iam_role_policy" "ecs_task_secrets_access" {
  name = "ecs-task-secrets-access"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SecretsAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}/api-keys-*",
          "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}/proxy-*"
        ]
      }
    ]
  })
}

# Outputs
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task.arn
}
