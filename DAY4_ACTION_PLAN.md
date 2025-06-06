# Day 4 Action Plan - Security Groups

## 🎯 Today's Goal: Implement AUT-003 (Security Groups)

### 📋 Pre-flight Checklist

Before starting, in WSL2:
```bash
# Navigate to project
cd ~/ai-updates-tracker

# Check current branch
git branch  # Should be on feature/AUT-002-vpc-infrastructure

# Merge VPC work to main
git checkout main
git merge feature/AUT-002-vpc-infrastructure
git push origin main  # After GitHub repo is created

# Create new feature branch
git checkout -b feature/AUT-003-security-groups
```

### 🚀 Step 1: Create GitHub Repository

```bash
# Install GitHub CLI if needed
gh --version || sudo apt install gh

# Authenticate with GitHub
gh auth login

# Create repository
gh repo create ai-updates-tracker --public --description "Automated AI news aggregation system"

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/ai-updates-tracker.git
git push -u origin main
```

### 📝 Step 2: Create Security Groups Module

```bash
# Navigate to infrastructure
cd ~/ai-updates-tracker/infrastructure/aws-foundation

# Create security groups file
touch security_groups.tf
```

### 🤖 Step 3: Use Claude to Generate Security Groups

Example prompt:
```
"Create Terraform configuration for security groups with these requirements:
- ALB security group: Allow inbound 80/443 from 0.0.0.0/0
- ECS security group: Allow all traffic from ALB security group
- Lambda security group: Allow all outbound, no inbound
- VPC Endpoints security group: Allow HTTPS from VPC CIDR
- All security groups should reference the VPC we created
- Use proper descriptions and tags"
```

### 🏗️ Step 4: Security Groups to Create

1. **ALB Security Group** (`alb_sg`)
   - Inbound: 80, 443 from internet
   - Outbound: All to ECS

2. **ECS Security Group** (`ecs_sg`)
   - Inbound: All from ALB
   - Outbound: 443 to internet (for APIs)
   - Outbound: 5432 to RDS (if used)

3. **Lambda Security Group** (`lambda_sg`)
   - Inbound: None
   - Outbound: 443 to internet
   - Outbound: To VPC endpoints

4. **VPC Endpoints Security Group** (`vpce_sg`)
   - Inbound: 443 from VPC CIDR
   - Outbound: None needed

### 🚀 Step 5: Deploy Security Groups

```bash
# Format and validate
terraform fmt
terraform validate

# Plan the changes
terraform plan

# Apply if looks good
terraform apply
```

### ✅ Step 6: Create GitHub Issues

```bash
# Use Claude CLI to create issues from your Jira stories
claude "Read the AI Updates Tracker project knowledge base and create GitHub issues for all AUT-XXX stories. Use the GitHub CLI to create them in the ai-updates-tracker repository."

# Or manually create key issues:
gh issue create --title "AUT-003: Security Groups and NACLs" --body "Create security groups for ALB, ECS, Lambda, and VPC Endpoints"
gh issue create --title "AUT-004: ECS Cluster Setup" --body "Set up ECS cluster for running containerized scrapers"
# ... etc
```

### 💰 Expected Costs

Security Groups themselves are free! No additional daily cost.

### 🎯 Success Criteria

By end of Day 4:
- ✅ GitHub repository created and code pushed
- ✅ All security groups created via Terraform
- ✅ Security groups properly tagged
- ✅ GitHub issues created for tracking
- ✅ Documentation updated
- ✅ Ready for ECS cluster setup

### 🚨 Common Issues & Solutions

1. **GitHub Authentication**
   ```bash
   gh auth login
   # Choose GitHub.com, HTTPS, authenticate with browser
   ```

2. **Security Group Dependencies**
   - Create them in order: VPC Endpoints → ALB → ECS → Lambda
   - Use `depends_on` if needed

3. **Circular Dependencies**
   - Use `aws_security_group_rule` resources instead of inline rules

### 📝 Documentation Updates

After completion:
1. Update SPRINT_TRACKING.md
2. Update COST_TRACKING.md (no new costs)
3. Commit all changes
4. Create PR if using GitHub flow

### 🎉 Day 4 Completion

Once done:
1. All security groups deployed
2. GitHub repo live with issues
3. Ready for Day 5: ECS Cluster (AUT-004)

Remember: Security groups are like firewalls for your AWS resources - they're critical for security!