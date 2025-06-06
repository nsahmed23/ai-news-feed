# AI Updates Tracker - Setup Checklist

## Day 2: Account Setup (Current) ✅ COMPLETED!

### AWS Account
- [x] Create AWS account at https://aws.amazon.com/ ✅
- [x] Enable MFA on root account ✅
- [x] Create IAM user for daily use (ai-updates-admin) ✅
- [x] Install AWS CLI v2 (v2.27.31 in WSL2) ✅
- [x] Configure AWS CLI with access keys ✅
- [x] Set up billing alerts ($50, $100, $200) ✅
- [x] Verify free tier status ✅

### Project Management
- [ ] Choose: Jira Free / GitHub Issues / Local Markdown
- [ ] Set up chosen system
- [ ] Import/create Week 1 stories

### Local Development Environment
- [x] Project directory created: C:/Projects/ai-updates-tracker ✅
- [x] Initial planning files in place ✅
- [x] WSL2 symlink created: ~/ai-updates-tracker ✅
- [ ] Git repository initialized
- [ ] GitHub repository created
- [ ] Initial commit pushed

### Tools Verification
- [ ] Terraform installed and working (check tomorrow)
- [x] AWS CLI installed and configured ✅
- [ ] Node.js 18+ installed
- [ ] Python 3.8+ installed (for scripts)

## Day 3: Start Week 1 Implementation

### AUT-001: AWS Account Configuration ✅ (Completed above)

### AUT-002: Network Foundation (VPC)
- [ ] Create terraform files for VPC
- [ ] Define CIDR blocks (10.0.0.0/16)
- [ ] Plan public/private subnets
- [ ] Implement and test

### AUT-003: Security Groups
- [ ] Define security group rules
- [ ] Create terraform configurations
- [ ] Apply and verify

## Quick Commands Reference

```bash
# Initialize git (if not done)
cd C:/Projects/ai-updates-tracker
git init
git add .
git commit -m "Initial project setup"

# Create GitHub repo (using GitHub CLI)
gh repo create ai-updates-tracker --private

# Configure AWS CLI (after account creation)
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output format (json)

# Test AWS access
aws sts get-caller-identity

# Initialize Terraform (when ready)
cd infrastructure/aws-foundation
terraform init
```

## Cost Tracking
Starting Budget Target: $400-500/month
- Development Phase: Aim for <$50/month
- Use free tier wherever possible
- Set up billing alerts immediately
