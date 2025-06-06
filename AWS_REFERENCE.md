# AWS Account Reference - AI Updates Tracker

## Account Details (Non-Sensitive)
- **Account Created**: December 3, 2024
- **IAM User**: ai-updates-admin
- **Primary Region**: us-east-1
- **Free Tier Expires**: December 3, 2025

## Important URLs
- **AWS Console**: https://console.aws.amazon.com/
- **IAM Sign-in**: https://279684395806.signin.aws.amazon.com/console
- **Billing Dashboard**: https://console.aws.amazon.com/billing/home
- **Free Tier Usage**: https://console.aws.amazon.com/billing/home#/freetier
- **Cost Explorer**: https://console.aws.amazon.com/cost-management/home#/cost-explorer

## Configured Resources

### Billing Alerts
- ✅ Development Budget: $50/month
- ✅ Safety Net Budget: $100/month  
- ✅ Emergency Budget: $200/month

### Security Configuration
- ✅ Root account MFA enabled
- ✅ IAM user MFA enabled
- ✅ IAM billing access activated

### Development Setup
- ✅ AWS CLI v2.27.31 installed in WSL2
- ✅ Credentials configured in ~/.aws/
- ✅ Default region: us-east-1
- ✅ Output format: json

## Common AWS CLI Commands

```bash
# Verify identity
aws sts get-caller-identity

# List S3 buckets (once created)
aws s3 ls

# List EC2 instances (once created)
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`].Value|[0]]' --output table

# Check current costs
aws ce get-cost-and-usage \
  --time-period Start=$(date -u -d "$(date +%Y-%m-01)" +%Y-%m-%d),End=$(date -u +%Y-%m-%d) \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
```

## Project-Specific Configuration

### Terraform Backend (To Be Created)
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket = "ai-updates-tracker-terraform-state"
    key    = "infrastructure/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### Default Tags (Use on All Resources)
```hcl
default_tags = {
  Project     = "ai-updates-tracker"
  Environment = "development"
  ManagedBy   = "terraform"
  Owner       = "ai-updates-admin"
  CostCenter  = "development"
}
```

## Security Best Practices Implemented

1. ✅ Never use root account for daily operations
2. ✅ MFA on all accounts
3. ✅ Principle of least privilege (to be refined)
4. ✅ Billing alerts for cost control
5. ⏳ IAM policies to be restricted after initial setup
6. ⏳ CloudTrail logging to be enabled
7. ⏳ S3 bucket encryption by default

## Next Infrastructure Components (Day 3+)

1. **VPC Foundation** (AUT-002)
   - CIDR: 10.0.0.0/16
   - 2 Public Subnets
   - 2 Private Subnets

2. **S3 Buckets** (AUT-005)
   - Terraform state bucket
   - Scraped data bucket
   - Static assets bucket

3. **ECS Cluster** (AUT-006)
   - Fargate launch type
   - 2vCPU/4GB for Playwright tasks

## Cost Optimization Reminders

- 🚫 Stop resources when not in use
- 📊 Check Free Tier usage weekly
- 💡 Use t3.micro/t4g.micro where possible
- 🔄 Delete old snapshots and AMIs
- 📦 Enable S3 lifecycle policies
