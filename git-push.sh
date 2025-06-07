#!/bin/bash
# Git commit and push script for AI Updates Tracker
# June 6, 2025 - Days 2-7 Infrastructure Completion

echo "🚀 Preparing to push AI Updates Tracker infrastructure to GitHub..."
echo "=================================================="

# Navigate to project root
cd ~/ai-updates-tracker

# Check current git status
echo -e "\n📊 Current Git Status:"
git status

# Initialize git if needed
if [ ! -d .git ]; then
    echo -e "\n🔧 Initializing git repository..."
    git init
    git branch -M main
fi

# Add all files
echo -e "\n📁 Adding all files to git..."
git add -A

# Show what's being committed
echo -e "\n📋 Files to be committed:"
git status --short

# Create comprehensive commit message
echo -e "\n✍️ Creating commit..."
git commit -m "feat: Complete AWS infrastructure setup (Days 2-7) 🏗️

Infrastructure completed on June 6, 2025:

Foundation Layer:
- ✅ Terraform backend (S3 + DynamoDB state management)
- ✅ IAM security baseline and policies
- ✅ CloudTrail audit logging
- ✅ AWS Config with 6 compliance rules
- ✅ SNS alerts to nsahmed23@gmail.com

Networking:
- ✅ VPC (10.0.0.0/16) with 2 AZs
- ✅ Public subnets (10.0.1.0/24, 10.0.2.0/24)
- ✅ Private subnets (10.0.11.0/24, 10.0.12.0/24)
- ✅ NAT Gateway (3.219.107.20) for outbound access
- ✅ Internet Gateway for inbound access
- ✅ 4 Security Groups (ALB, ECS, Lambda, VPC Endpoints)
- ✅ VPC Flow Logs enabled

Compute:
- ✅ ECS Cluster (ai-updates-tracker-development)
- ✅ ECR Repository (ai-news-feed-development)
- ✅ Task execution and task roles

Storage:
- ✅ S3 bucket for scraped data (private)
- ✅ S3 bucket for static website (public)
- ✅ S3 buckets for CloudTrail, Config, and Terraform state

Monitoring:
- ✅ CloudWatch log groups for all services
- ✅ CloudWatch dashboard
- ✅ CPU utilization alarms
- ✅ Comprehensive logging strategy

Security Enhancements:
- ✅ EBS encryption enabled by default
- ✅ All S3 buckets encrypted
- ✅ Root account MFA verified
- ✅ Security additions (additional Config rules)

Project Structure:
- 📁 infrastructure/aws-foundation/ - Terraform configs
- 📁 infrastructure/ - Architecture diagrams
- 📄 SECURITY_CHECKLIST.md - Security tracking
- 📄 Multiple knowledge base documents

Account Details:
- AWS Account: 279684395806
- Region: us-east-1
- Environment: development"

echo -e "\n🔗 Setting up GitHub remote (if needed)..."
# Check if remote exists
if ! git remote | grep -q "origin"; then
    echo "Please enter your GitHub repository URL:"
    echo "Example: https://github.com/yourusername/ai-updates-tracker.git"
    read -p "GitHub URL: " github_url
    
    if [ ! -z "$github_url" ]; then
        git remote add origin "$github_url"
        echo "✅ Remote 'origin' added: $github_url"
    else
        echo "⚠️ No URL provided. You'll need to add the remote manually:"
        echo "   git remote add origin <your-github-url>"
    fi
else
    echo "✅ Remote 'origin' already configured:"
    git remote -v
fi

echo -e "\n📤 Ready to push to GitHub!"
echo "To push your changes, run:"
echo "   git push -u origin main"
echo ""
echo "If this is your first push, you may need to:"
echo "1. Create the repository on GitHub first"
echo "2. Set up authentication (SSH key or personal access token)"
echo ""
echo "For HTTPS authentication, use a personal access token instead of password."
echo "Create one at: https://github.com/settings/tokens"
