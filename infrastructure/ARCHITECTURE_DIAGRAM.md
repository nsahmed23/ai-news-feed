# AI Updates Tracker - Infrastructure Architecture
## As of June 6, 2025

## 🏗️ Infrastructure Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AWS Account (us-east-1)                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────── VPC (10.0.0.0/16) ────────────────────────┐  │
│  │                                                                       │  │
│  │  ┌─── Public Subnet 1 ───┐    ┌─── Public Subnet 2 ───┐            │  │
│  │  │   10.0.1.0/24 (1a)    │    │   10.0.2.0/24 (1b)    │            │  │
│  │  │                       │    │                       │            │  │
│  │  │  ┌──────────────┐    │    │  ┌─────────────┐     │            │  │
│  │  │  │ NAT Gateway  │    │    │  │ (Future ALB) │     │            │  │
│  │  │  │ 3.219.107.20 │    │    │  └─────────────┘     │            │  │
│  │  │  └──────────────┘    │    │                       │            │  │
│  │  └───────────────────────┘    └───────────────────────┘            │  │
│  │           │                              │                          │  │
│  │           │ Routes                       │ Routes                   │  │
│  │           ▼                              ▼                          │  │
│  │  ┌─── Private Subnet 1 ──┐    ┌─── Private Subnet 2 ──┐           │  │
│  │  │   10.0.11.0/24 (1a)   │    │   10.0.12.0/24 (1b)   │           │  │
│  │  │                       │    │                       │           │  │
│  │  │  ┌────────────────┐  │    │  ┌────────────────┐  │           │  │
│  │  │  │  ECS Tasks     │  │    │  │  ECS Tasks     │  │           │  │
│  │  │  │  (Scrapers)    │  │    │  │  (API/Workers) │  │           │  │
│  │  │  └────────────────┘  │    │  └────────────────┘  │           │  │
│  │  └───────────────────────┘    └───────────────────────┘           │  │
│  │                                                                     │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌───────── Internet Gateway ─────────┐                                   │
│  │  Inbound/Outbound Internet Access  │                                   │
│  └────────────────────────────────────┘                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 🔐 Security Architecture

```
┌─────────────────── Security & Compliance Layer ────────────────────┐
│                                                                     │
│  CloudTrail ──────► CloudWatch Logs ──────► S3 Bucket             │
│      │                    │                  (Encrypted)            │
│      │                    │                                         │
│      └──────────────────► CloudWatch Dashboard                     │
│                                                                     │
│  AWS Config ──────► 6 Compliance Rules ──────► SNS Alerts         │
│      │                                          │                   │
│      └──────────────► S3 Bucket                 └─► Email          │
│                       (Config Data)                  nsahmed23@     │
│                                                                     │
│  VPC Flow Logs ──────► CloudWatch Logs                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## 💾 Storage Architecture

```
┌──────────────────── S3 Buckets (5 Total) ─────────────────────┐
│                                                                │
│  1. ai-news-feed-development-scraped-data-991el7cv           │
│     └─► Private bucket for scraped AI updates                 │
│                                                                │
│  2. ai-news-feed-development-static-assets-991el7cv          │
│     └─► Public website hosting (frontend)                     │
│                                                                │
│  3. ai-news-feed-development-cloudtrail-991el7cv             │
│     └─► Audit logs (lifecycle: 30d→IA, 90d→Glacier, 365d)    │
│                                                                │
│  4. ai-news-feed-development-config-991el7cv                 │
│     └─► AWS Config compliance data                            │
│                                                                │
│  5. ai-news-feed-terraform-state-991el7cv                    │
│     └─► Terraform state files (versioned)                     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

## 🖥️ Compute Resources

```
┌───────────────── Container Infrastructure ─────────────────┐
│                                                             │
│  ECR Repository                  ECS Cluster               │
│  ┌─────────────────┐            ┌─────────────────┐       │
│  │ ai-news-feed-   │            │ ai-updates-     │       │
│  │ development     │ ─────────► │ tracker-        │       │
│  │                 │  Images    │ development     │       │
│  └─────────────────┘            └─────────────────┘       │
│                                          │                  │
│                                          ▼                  │
│                                  ┌─────────────┐           │
│                                  │ Fargate     │           │
│                                  │ Tasks       │           │
│                                  └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## 🔒 Security Groups & Network ACLs

```
Security Groups (Stateful):
├── ALB Security Group (sg-003188a58a3eb2680)
│   └── Allows HTTPS (443) from Internet
│
├── ECS Tasks Security Group (sg-0c7528038e7759422)
│   └── Allows traffic from ALB SG only
│
├── Lambda Security Group (sg-0b319e589a7cf06de)
│   └── Allows outbound HTTPS for web scraping
│
└── VPC Endpoints Security Group (sg-043de2c4bc7bb32c8)
    └── Allows HTTPS from within VPC
```

## 📊 Monitoring & Observability

```
CloudWatch Components:
├── Log Groups
│   ├── /ecs/ai-updates-tracker-development
│   ├── /aws/application/ai-updates-tracker-development
│   ├── /aws/scrapers/ai-updates-tracker-development
│   ├── /aws/vpc/ai-updates-tracker-development
│   └── /aws/cloudtrail/ai-updates-tracker-development
│
├── Dashboard
│   └── ai-updates-tracker-development-dashboard
│
└── Alarms
    └── ECS CPU High (>80%)
```

## 🔑 IAM Roles

```
IAM Roles Created:
├── ECS Task Role
│   ├── S3 access (scraped data + static assets)
│   ├── Secrets Manager access
│   └── DynamoDB access
│
├── ECS Task Execution Role
│   ├── ECR image pull
│   └── CloudWatch logs write
│
├── CloudTrail Role
│   └── CloudWatch logs write
│
├── Config Role
│   └── Resource configuration read
│
└── VPC Flow Logs Role
    └── CloudWatch logs write
```

## 🚀 Data Flow (Future State)

```
1. Web Scraping Flow:
   Internet ──► NAT GW ──► ECS Task (Scraper) ──► S3 (Scraped Data)
                                │
                                └──► CloudWatch Logs

2. API Flow:
   Users ──► ALB ──► ECS Task (API) ──► S3 (Read Data)
                           │
                           └──► CloudWatch Logs

3. Static Website:
   Users ──► S3 Static Website Bucket (Direct Access)
```

## 💰 Cost Breakdown

```
Daily Costs (Estimated):
├── NAT Gateway: ~$1.08/day + data transfer
├── VPC: Free
├── S3 Buckets: ~$0.10/day (minimal data)
├── CloudTrail: ~$0.10/day
├── Config: ~$0.20/day
├── CloudWatch: ~$0.50/day
├── ECS Cluster: Free (pay per task)
└── Total: ~$2-3/day baseline (before running tasks)
```

## 🎯 Next Steps

1. **Secrets Manager**: Store API keys and proxy credentials
2. **Lambda Functions**: Create scrapers for RSS feeds
3. **ECS Task Definitions**: Define Playwright scrapers
4. **API Gateway/ALB**: Set up API endpoints
5. **Deploy Frontend**: Upload to S3 static website bucket
