# AI Updates Tracker

An automated system for tracking and aggregating AI news and updates from major AI companies.

## Project Overview

This project automatically collects, processes, and presents the latest updates from:
- OpenAI
- Anthropic
- Google AI
- Meta AI
- Microsoft AI
- DeepSeek
- And more...

## Architecture

- **Backend**: AWS-based infrastructure using Terraform
- **Scraping**: Playwright-based web scrapers on AWS Fargate
- **Storage**: AWS S3 and DynamoDB
- **Frontend**: Static site with CDN distribution
- **Automation**: AWS Lambda and EventBridge for scheduled updates

## Development Timeline

- **Week 1-2**: AWS Infrastructure Setup (Current Phase)
- **Week 3-4**: Backend Development
- **Week 5-6**: Web Scraping Implementation
- **Week 7-8**: Frontend Development
- **Week 9-10**: Testing & Optimization
- **Week 11-12**: Production Deployment
- **Week 13-14**: Monitoring & Final Adjustments

## Quick Start

```bash
# Clone the repository
git clone [repository-url]

# Navigate to project
cd ai-updates-tracker

# Follow setup instructions in docs/
```

## Project Structure

```
ai-updates-tracker/
├── infrastructure/       # Terraform configurations
├── backend/             # API and services
├── scrapers/            # Web scraping modules
├── frontend/            # Static site files
├── docs/                # Documentation
└── scripts/             # Utility scripts
```

## Budget

- Development: < $50/month
- Production: $400-500/month

## Status

🚧 **Currently in Development** - Day 3 of 98

---

Built with ❤️ for the AI community
