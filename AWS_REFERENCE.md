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

## Deployed Infrastructure (As of Day 5)

### ✅ VPC Foundation (AUT-002) - Day 3
- **VPC ID**: vpc-08506c0612f98b7f9
- **CIDR**: 10.0.0.0/16
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24
- **Private Subnets**: 10.0.11.0/24, 10.0.12.0/24
- **NAT Gateway IP**: 3.219.107.20

### ✅ Security Groups (AUT-003) - Day 4
- **ALB SG**: sg-003188a58a3eb2680
- **ECS Tasks SG**: sg-0c7528038e7759422
- **Lambda SG**: sg-0b319e589a7cf06de
- **VPC Endpoints SG**: sg-043de2c4bc7bb32c8
- **RDS SG**: Optional (variable controlled)

### 🔄 ECS Cluster (AUT-004) - Day 5 (Ready to Deploy)
- **Cluster Name**: ai-news-feed-development-cluster
- **Container Insights**: Enabled
- **Capacity Providers**: FARGATE, FARGATE_SPOT
- **IAM Roles**: Task execution and application roles created

### 📋 Next Components

1. **S3 Buckets** (AUT-005)
   - Terraform state bucket
   - Scraped data bucket
   - Static assets bucket

2. **ECR Repository** (AUT-006)
   - Docker image registry
   - Lifecycle policies

3. **Application Load Balancer** (AUT-007)
   - Public-facing ALB
   - Target groups

## Cost Optimization Reminders

- 🚫 Stop resources when not in use
- 📊 Check Free Tier usage weekly
- 💡 Use t3.micro/t4g.micro where possible
- 🔄 Delete old snapshots and AMIs
- 📦 Enable S3 lifecycle policies
