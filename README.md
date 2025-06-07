# 🤖 AI Updates Tracker

![AWS Infrastructure](https://img.shields.io/badge/AWS-Infrastructure_Complete-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/Terraform-v1.6.6-purple?logo=terraform)
![Status](https://img.shields.io/badge/Status-Foundation_Complete-success)
![Progress](https://img.shields.io/badge/Progress-Days_2--7_Complete-blue)

A comprehensive web application that tracks and aggregates the latest updates from major AI companies (OpenAI, Anthropic, Google, Meta, Microsoft, DeepSeek, etc.) using automated data fetching, AI-powered description generation, and a modern web interface.

## 📅 Project Timeline

- **Project Start**: June 6, 2025
- **Current Status**: Infrastructure deployment complete (Days 2-7 done in 1 day! 🚀)
- **Environment**: Development
- **AWS Region**: us-east-1

## 🏗️ Architecture Overview

```
RSS Feeds / Web Scraping / APIs
            │
            ▼
    Cloud Scheduler (every 2 hours)
            │
            ▼
    ECS Fargate / Lambda Functions
            │
            ▼
    S3 Storage ◄──── AI Processing (Future)
            │
            ▼
    Express API (ECS)
            │
            ▼
    Static Frontend (S3)
```

## ✅ Completed Infrastructure (June 6, 2025)

### Foundation Layer
- ✅ Terraform backend (S3 + DynamoDB state management)
- ✅ IAM security baseline and policies
- ✅ CloudTrail audit logging
- ✅ AWS Config with 6 compliance rules
- ✅ SNS alerts configured

### Networking
- ✅ VPC (10.0.0.0/16) with 2 AZs
- ✅ Public/Private subnet architecture
- ✅ NAT Gateway for outbound access
- ✅ Security Groups configured
- ✅ VPC Flow Logs enabled

### Compute & Storage
- ✅ ECS Cluster ready for containers
- ✅ ECR Repository for Docker images
- ✅ 5 S3 buckets (data, static site, logs, config, state)
- ✅ All encryption enabled

### Monitoring & Security
- ✅ CloudWatch logging infrastructure
- ✅ Monitoring dashboard
- ✅ 6 Config compliance rules
- ✅ Email alerts via SNS

## 🚀 Next Steps

### Week 2: Application Layer
- [ ] Lambda functions for RSS scraping
- [ ] ECS tasks for Playwright web scraping
- [ ] Express.js API development
- [ ] Frontend implementation
- [ ] Data pipeline setup

### Week 3: Integration & Testing
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Security hardening
- [ ] Documentation

## 💻 Development Setup

### Prerequisites
- AWS Account
- Terraform >= 1.6.6
- AWS CLI v2
- Node.js >= 18
- Python >= 3.9
- Docker

### Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/ai-updates-tracker.git
cd ai-updates-tracker

# Set up AWS credentials
aws configure

# Deploy infrastructure
cd infrastructure/aws-foundation
terraform init
terraform plan
terraform apply

# Environment variables needed
export AWS_REGION=us-east-1
export ENVIRONMENT=development
```

## 📁 Project Structure

```
ai-updates-tracker/
├── infrastructure/
│   ├── aws-foundation/     # Terraform configs
│   ├── lambda/            # Lambda functions (coming soon)
│   ├── ecs-tasks/         # ECS task definitions (coming soon)
│   └── alb/               # Load balancer config (coming soon)
├── application/
│   ├── scrapers/          # Web scraping logic (coming soon)
│   ├── api/               # Express.js API (coming soon)
│   ├── frontend/          # Static website (coming soon)
│   └── shared/            # Shared utilities (coming soon)
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## 💰 Cost Optimization

Current infrastructure costs (estimated):
- **Daily**: $15-20 (mainly NAT Gateway)
- **Monthly**: $450-600

Cost-saving measures implemented:
- Single NAT Gateway (not HA for development)
- Fargate Spot for non-critical tasks
- S3 lifecycle policies
- Scheduled scaling (future)

## 🔒 Security

- Root account MFA enabled ✅
- EBS encryption by default ✅
- All S3 buckets encrypted ✅
- CloudTrail logging active ✅
- Config compliance monitoring ✅
- VPC Flow Logs enabled ✅

## 📊 Monitoring

- CloudWatch Dashboard: [Link](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=ai-updates-tracker-development-dashboard)
- Log Groups configured for all services
- SNS alerts for critical events
- Cost monitoring enabled

## 🤝 Contributing

This is currently a solo project, but contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

MIT License - See LICENSE file for details

## 📞 Contact

- Email: nsahmed23@gmail.com
- Project Status Updates: Check the Issues tab

---

**Note**: This project is under active development. Infrastructure is complete, application layer coming next!

Built with ❤️ and lots of ☕ on June 6, 2025
