#!/bin/bash
# GitHub Setup Automation Script for AI News Feed

echo "🚀 Setting up GitHub repository structure..."

REPO="nsahmed23/ai-news-feed"

# Create labels
echo "📌 Creating labels..."
gh label create infrastructure --repo $REPO --description "Infrastructure related tasks" --color 0E8A16 2>/dev/null
gh label create terraform --repo $REPO --description "Terraform infrastructure as code" --color 7B55D7 2>/dev/null
gh label create completed --repo $REPO --description "Task completed" --color 28A745 2>/dev/null
gh label create backend --repo $REPO --description "Backend development" --color 1D76DB 2>/dev/null
gh label create frontend --repo $REPO --description "Frontend development" --color D93F0B 2>/dev/null
gh label create week-1 --repo $REPO --description "Week 1 sprint" --color FFA500 2>/dev/null
gh label create week-2 --repo $REPO --description "Week 2 sprint" --color FFA500 2>/dev/null
gh label create p0-critical --repo $REPO --description "Critical priority" --color FF0000 2>/dev/null
gh label create p1-high --repo $REPO --description "High priority" --color FF6B6B 2>/dev/null
gh label create p2-medium --repo $REPO --description "Medium priority" --color FFD93D 2>/dev/null

echo "✅ Labels created!"

# Create Week 1 issues
echo "📝 Creating Week 1 issues..."

# AUT-001
ISSUE1=$(gh issue create --repo $REPO \
  --title "AUT-001: AWS Account Setup and Configuration" \
  --body "✅ COMPLETED on Day 2

## Description
Set up AWS account with proper security configurations for the AI News Feed project.

## Acceptance Criteria
- [x] AWS account created with unique email
- [x] MFA enabled on root account  
- [x] IAM user 'ai-updates-admin' created
- [x] MFA enabled on IAM user
- [x] AWS CLI v2 installed and configured in WSL2
- [x] Billing alerts configured (\$50, \$100, \$200)
- [x] Free tier status verified (12 months remaining)

## Outcome
- Account ID: 279684395806
- IAM User: ai-updates-admin
- Region: us-east-1
- All security best practices implemented")

gh issue edit $ISSUE1 --repo $REPO --add-label "infrastructure,completed,week-1"
gh issue close $ISSUE1 --repo $REPO --comment "✅ Completed on Day 2 (Dec 3, 2024)"

# AUT-002
ISSUE2=$(gh issue create --repo $REPO \
  --title "AUT-002: Network Foundation (VPC, Subnets, Gateways)" \
  --body "✅ COMPLETED on Day 3

## Description
Create VPC infrastructure with Terraform for network isolation and security.

## Acceptance Criteria
- [x] VPC created with CIDR 10.0.0.0/16
- [x] 2 public subnets (10.0.1.0/24, 10.0.2.0/24) across AZs
- [x] 2 private subnets (10.0.11.0/24, 10.0.12.0/24) across AZs
- [x] Internet Gateway attached
- [x] NAT Gateway configured (single, not HA)
- [x] Route tables properly configured
- [x] VPC Flow Logs enabled
- [x] All resources tagged with Terraform

## Outcome
- VPC ID: vpc-08506c0612f98b7f9
- NAT Gateway IP: 3.219.107.20
- Infrastructure as Code in: infrastructure/aws-foundation/
- Cost: ~\$1.10/day (NAT Gateway)")

gh issue edit $ISSUE2 --repo $REPO --add-label "infrastructure,terraform,completed,week-1"
gh issue close $ISSUE2 --repo $REPO --comment "✅ Completed on Day 3 (June 6, 2025)"

# AUT-003
gh issue create --repo $REPO \
  --title "AUT-003: Security Groups and NACLs" \
  --body "## Description
Create security groups for all application components to control network access.

## Acceptance Criteria
- [ ] ALB security group
  - Inbound: 80, 443 from 0.0.0.0/0
  - Outbound: All traffic to ECS security group
- [ ] ECS security group  
  - Inbound: All traffic from ALB security group
  - Outbound: 443 to internet, 5432 to RDS
- [ ] Lambda security group
  - Inbound: None
  - Outbound: 443 to internet and VPC endpoints
- [ ] VPC Endpoints security group
  - Inbound: 443 from VPC CIDR
- [ ] All security groups reference VPC ID from AUT-002
- [ ] Proper descriptions and tags applied

## Technical Requirements
- Use Terraform security_groups.tf
- Reference existing VPC outputs
- Implement least privilege principle" \
  --label "infrastructure,terraform,week-1,p0-critical"

# AUT-004
gh issue create --repo $REPO \
  --title "AUT-004: ECS Cluster Setup" \
  --body "## Description
Set up ECS cluster with Fargate for running containerized web scrapers.

## Acceptance Criteria
- [ ] ECS cluster created with Terraform
- [ ] Fargate capacity providers configured
- [ ] Task execution IAM role created
- [ ] CloudWatch log groups set up
- [ ] Auto-scaling policies defined
- [ ] Cluster configured for 2vCPU/4GB tasks (Playwright requirements)
- [ ] Cost optimization settings applied

## Technical Requirements
- Use Fargate Spot for cost savings where possible
- Configure tasks for Playwright browser automation
- Set up proper networking with private subnets
- Reference VPC outputs from AUT-002" \
  --label "infrastructure,terraform,week-1,p0-critical"

# AUT-005
gh issue create --repo $REPO \
  --title "AUT-005: S3 Buckets Creation" \
  --body "## Description
Create S3 buckets for data storage, static assets, and Terraform state.

## Acceptance Criteria
- [ ] Scraped data bucket
  - Lifecycle policies (move to Glacier after 90 days)
  - Versioning enabled
  - Server-side encryption
- [ ] Static assets bucket
  - Public read for frontend assets
  - CloudFront distribution ready
  - CORS configuration
- [ ] Terraform state bucket
  - Versioning enabled
  - Bucket encryption
  - State locking with DynamoDB
- [ ] All buckets tagged appropriately

## Technical Requirements
- Use Terraform s3.tf module
- Implement least privilege bucket policies
- Enable access logging
- Cost optimization with lifecycle rules" \
  --label "infrastructure,terraform,week-1,p1-high"

echo "✅ GitHub setup complete!"
echo "📊 Summary:"
echo "- Labels created: 10"
echo "- Issues created: 5"
echo "- Completed issues: 2 (AUT-001, AUT-002)"
echo "- Open issues: 3 (AUT-003, AUT-004, AUT-005)"
echo ""
echo "View your issues at: https://github.com/$REPO/issues"
