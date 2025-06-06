# Day 3 Action Plan - Network Foundation

## 🎯 Today's Goal: Implement AUT-002 (VPC Infrastructure)

### 📋 Pre-flight Checklist

Before starting, verify in WSL2:
```bash
# Check you're in the right place
cd ~/ai-updates-tracker
pwd  # Should show: /home/nsahmed/ai-updates-tracker

# Verify AWS CLI is working
aws sts get-caller-identity

# Install Terraform if needed
terraform --version || {
  wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
  unzip terraform_1.6.6_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm terraform_1.6.6_linux_amd64.zip
}
```

### 🏗️ Step 1: Create Terraform Structure

```bash
# Create the infrastructure directory structure
cd ~/ai-updates-tracker
mkdir -p infrastructure/aws-foundation/{modules,environments}
cd infrastructure/aws-foundation

# Initialize git (if not done yet)
git init
git add .
git commit -m "Initial project setup - Day 2 complete"
```

### 📝 Step 2: Create Base Terraform Files

You'll create these files using Claude:

1. **providers.tf** - AWS provider configuration
2. **variables.tf** - Input variables
3. **vpc.tf** - VPC and subnet configuration  
4. **outputs.tf** - Output values
5. **terraform.tfvars** - Variable values

### 🤖 Step 3: Use Claude to Generate Configs

Example prompt for Claude:
```
"Create Terraform configuration for AWS VPC with these requirements:
- VPC CIDR: 10.0.0.0/16
- 2 public subnets (10.0.1.0/24, 10.0.2.0/24) in different AZs
- 2 private subnets (10.0.11.0/24, 10.0.12.0/24) in different AZs
- Internet Gateway
- NAT Gateway (single, not HA for cost savings)
- Route tables for public and private subnets
- Enable DNS hostnames and DNS resolution
- Tag everything with Project=ai-updates-tracker, Environment=development"
```

### 🚀 Step 4: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan deployment (review carefully!)
terraform plan

# Apply if everything looks good
terraform apply
# Type 'yes' when prompted
```

### ✅ Step 5: Verify Deployment

```bash
# Check VPC was created
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=ai-updates-tracker"

# Check subnets
aws ec2 describe-subnets --filters "Name=tag:Project,Values=ai-updates-tracker"

# Save state
git add .
git commit -m "Day 3: VPC infrastructure deployed"
```

### 💰 Expected Costs

For Day 3 VPC deployment:
- VPC: $0 (free)
- Subnets: $0 (free)
- Internet Gateway: $0 (free)
- NAT Gateway: ~$0.045/hour = ~$1.08/day
- **Total Day 3**: ~$1.08

### 🎯 Success Criteria

By end of Day 3, you should have:
- ✅ VPC created with proper CIDR
- ✅ 4 subnets (2 public, 2 private) across 2 AZs
- ✅ Internet Gateway attached
- ✅ NAT Gateway in one public subnet
- ✅ Route tables configured correctly
- ✅ All resources tagged properly
- ✅ Terraform state file saved
- ✅ Code committed to git

### 🚨 Common Issues & Solutions

1. **Terraform not found**
   - Install using the commands above

2. **AWS credentials error**
   - Run: `aws configure list`
   - Ensure credentials are set

3. **Insufficient permissions**
   - Your IAM user has AdministratorAccess, should work
   - If issues, check IAM user permissions

4. **Region issues**
   - Ensure you're in us-east-1
   - Check: `aws configure get region`

### 📞 Getting Help

If stuck:
1. Share the exact error message with Claude
2. Include the Terraform file causing issues
3. Run `terraform plan` to see what will change

### 🎉 Day 3 Completion

Once VPC is deployed:
1. Update SPRINT_TRACKING.md
2. Add today's costs to COST_TRACKING.md  
3. Prepare for Day 4 (Security Groups - AUT-003)

Good luck! You're building real cloud infrastructure now! 🚀
