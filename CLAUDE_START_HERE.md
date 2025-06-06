# 🚀 CLAUDE START HERE - AI News Feed Project Context

## 📋 Quick Project Overview
**Project**: AI News Feed (formerly ai-updates-tracker) - Enterprise-grade automated AI news aggregation system
**User**: Nazeer Ahmed (nsahmed23) - Solo developer wanting "enterprise feel"
**Environment**: Windows 11 with WSL2 Ubuntu 24.04, using Cursor IDE
**Current Status**: Day 3 Complete - VPC Infrastructure Deployed
**GitHub Repo**: https://github.com/nsahmed23/ai-news-feed

## 🗂️ Essential Files to Read (In Order)

### 1. **Current Context**
- **`CLAUDE_CONTEXT_DAY4.md`** - START HERE! Has Day 3 completion summary and what's next
- **`DAY4_ACTION_PLAN.md`** - Step-by-step guide for Day 4 (Security Groups)

### 2. **Project Knowledge**
- **`.cursorrules`** - CRITICAL! Defines cost constraints ($200/month hard limit)
- **`SPRINT_TRACKING.md`** - Shows completed tasks (AUT-001, AUT-002) and upcoming work
- **`COST_TRACKING.md`** - Current costs (~$1.10/day for NAT Gateway)
- **`AWS_REFERENCE.md`** - AWS account details and common commands

### 3. **Architecture & Infrastructure**
- **`infrastructure/aws-foundation/`** - All Terraform files for VPC
- **`infrastructure/aws-foundation/terraform.tfstate`** - Current infrastructure state
- **`ai_updates_tracker_architecture.png`** - System design diagram

## 🔑 Key Information

### AWS Infrastructure (Live & Running)
```bash
AWS Account ID: 279684395806
IAM User: ai-updates-admin
Region: us-east-1
VPC ID: vpc-08506c0612f98b7f9
NAT Gateway IP: 3.219.107.20
```

### Technology Stack Decisions
- **Infrastructure**: Terraform (not CloudFormation)
- **Web Scraping**: Playwright on Fargate (2vCPU/4GB tasks)
- **Environments**: 3 only - Dev/Staging/Prod (NOT 4)
- **CI/CD**: GitHub Actions (not Jenkins)
- **Issue Tracking**: GitHub Issues (not Jira)
- **Costs**: Single NAT Gateway (not HA pair) to save $45/month

### Development Approach
- Using "Jira story format" (AUT-XXX) but tracking in GitHub Issues
- Feature branch workflow: `feature/AUT-XXX-description`
- Comprehensive documentation for every decision
- Claude CLI for automation (see `scripts/setup-github-issues.sh`)

### Current Git Status
- On branch: `feature/AUT-002-vpc-infrastructure`
- All changes pushed to GitHub
- Ready to start new branch for Day 4

## 💡 Important Context

### What User Values
1. **Enterprise feel** despite being solo developer
2. **Cost consciousness** - Tracks every dollar
3. **Comprehensive documentation** - Wants everything recorded
4. **Automation** - Uses Claude CLI to avoid repetitive tasks
5. **Best practices** - Proper Git flow, IaC, security

### What's Different About This Project
- User has **14 weeks** (98 days) for complete implementation
- Budget is **$400-500/month** for production (not typical $200)
- Already has comprehensive Jira stories in project knowledge base
- Wants to use MCP (Model Context Protocol) servers later

### Common Commands User Runs
```bash
# Always starts in WSL2
cd ~/ai-updates-tracker
aws sts get-caller-identity
terraform plan
claude "command here"
gh issue create
```

## 🎯 Day 4 Objectives

The user will likely want to:
1. Create new feature branch for AUT-003
2. Implement Security Groups with Terraform
3. Continue using Claude CLI for automation
4. Maintain comprehensive documentation

## ⚠️ Things to Remember

1. **Today is June 6, 2025** (not 2024)
2. **NAT Gateway is running** - Costing $1.10/day
3. **GitHub repo name changed** - Now "ai-news-feed" not "ai-updates-tracker"
4. **User prefers automation** - Suggest Claude CLI commands
5. **Cost tracking is important** - Update COST_TRACKING.md
6. **Windows paths**: `C:\Projects\ai-updates-tracker`
7. **WSL2 paths**: `~/ai-updates-tracker` (symlink)

## 📚 Project Timeline

- **Week 1-2**: Infrastructure ← CURRENT (Day 3 of 14)
- **Week 3-4**: Backend Development
- **Week 5-6**: Frontend Development
- **Week 7-8**: Testing
- **Week 9-10**: Production Deployment
- **Week 11-12**: Monitoring
- **Week 13-14**: Documentation & Handover

## 🤖 Claude CLI Usage

User loves using Claude CLI for automation. Example from today:
```bash
claude "Execute the bash script located at scripts/setup-github-issues.sh..."
```

Always suggest Claude CLI commands when repetitive tasks arise.

## 📝 Final Notes

- User completed Day 3 successfully with VPC deployment
- GitHub issues are all created and organized
- Infrastructure is live and incurring costs
- Everything is documented and tracked
- User is happy with progress and automation

**Start by reading `CLAUDE_CONTEXT_DAY4.md` for the most recent context!**

---
*Last Updated: End of Day 3, June 6, 2025*