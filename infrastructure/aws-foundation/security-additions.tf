# Additional Security Components

# Enable Security Hub (Uncomment when ready - adds ~$10-20/month)
# resource "aws_securityhub_account" "main" {
#   enable_default_standards = true
#   auto_enable_controls     = true
# }

# Enable GuardDuty (Uncomment when ready - adds ~$30-50/month)
# resource "aws_guardduty_detector" "main" {
#   enable = true
#
#   datasources {
#     s3_logs {
#       enable = true
#     }
#   }
#
#   finding_publishing_frequency = "FIFTEEN_MINUTES"
#
#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }

# Additional Config Rules
resource "aws_config_config_rule" "root_mfa" {
  name = "root-account-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
  
  depends_on = [aws_config_configuration_recorder_status.main]
}

resource "aws_config_config_rule" "ebs_encryption" {
  name = "ebs-encryption-by-default"

  source {
    owner             = "AWS"
    source_identifier = "EC2_EBS_ENCRYPTION_BY_DEFAULT"
  }
  
  depends_on = [aws_config_configuration_recorder_status.main]
}

resource "aws_config_config_rule" "rds_encryption" {
  name = "rds-encryption-enabled"

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
  
  depends_on = [aws_config_configuration_recorder_status.main]
}

# Create SNS topic for security alerts
resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-${var.environment}-security-alerts"
  
  kms_master_key_id = "alias/aws/sns"
  
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "security_alerts_email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = "nsahmed23@gmail.com"  # TODO: Update this
}

# CloudWatch Event Rule for GuardDuty findings (Uncomment when GuardDuty is enabled)
# resource "aws_cloudwatch_event_rule" "guardduty_findings" {
#   name        = "${var.project_name}-${var.environment}-guardduty-findings"
#   description = "Capture GuardDuty findings"
#
#   event_pattern = jsonencode({
#     source      = ["aws.guardduty"]
#     detail-type = ["GuardDuty Finding"]
#     detail = {
#       severity = [
#         4, 4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9,
#         5, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9,
#         6, 6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9,
#         7, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9,
#         8, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9
#       ]
#     }
#   })
#
#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     ManagedBy   = "terraform"
#   }
# }
#
# resource "aws_cloudwatch_event_target" "sns" {
#   rule      = aws_cloudwatch_event_rule.guardduty_findings.name
#   target_id = "SendToSNS"
#   arn       = aws_sns_topic.security_alerts.arn
# }

# Outputs for security resources
output "security_alerts_topic_arn" {
  value       = aws_sns_topic.security_alerts.arn
  description = "ARN of the SNS topic for security alerts"
}

# output "guardduty_detector_id" {
#   value       = aws_guardduty_detector.main.id
#   description = "GuardDuty detector ID"
# }
