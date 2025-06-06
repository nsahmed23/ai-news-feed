# AWS Cost Tracking - AI Updates Tracker

## Budget Overview
- **Monthly Target**: $400-500 (production)
- **Development Target**: <$50/month
- **Current Month**: June 2025

---

## Cost Tracking Log

### June 2025

| Date | Service | Description | Cost | Running Total |
|------|---------|-------------|------|---------------|
| June 6 | VPC | VPC, Subnets, IGW, Route Tables | $0.00 | $0.00 |
| June 6 | NAT Gateway | Single NAT Gateway deployed | $1.08/day | $1.08/day |
| June 6 | VPC Flow Logs | CloudWatch Logs (minimal) | ~$0.02/day | $1.10/day |
| June 6 | Security Groups | ALB, ECS, Lambda, VPC Endpoints, RDS SGs | $0.00 | $1.10/day |
| June 7 | ECS Cluster | ECS cluster (no running tasks yet) | $0.00 | $1.10/day |
| June 7 | CloudWatch | Log groups, dashboard, Container Insights | ~$0.05/day | $1.15/day |

**Daily Total**: $1.15/day
**Projected June Total (25 days from June 6)**: ~$28.75

---

## Free Tier Usage (12 months from account creation)

### Compute
- **EC2**: 750 hours/month t2.micro ✅
- **Lambda**: 1M requests/month ✅
- **ECS Fargate**: Not free tier ⚠️

### Storage  
- **S3**: 5GB storage, 20k GET, 2k PUT ✅
- **EBS**: 30GB SSD storage ✅

### Database
- **RDS**: 750 hours db.t2.micro ✅
- **DynamoDB**: 25GB storage, 25 RCU/WCU ✅

### Network
- **CloudFront**: 50GB transfer ✅
- **NAT Gateway**: Not free tier ($0.045/hour) ⚠️
- **ALB**: Not free tier ($0.0225/hour) ⚠️

---

## Cost Optimization Notes

### High-Cost Services to Monitor
1. **NAT Gateway**: ~$32/month (if running 24/7)
2. **ALB**: ~$16/month (if running 24/7)  
3. **ECS Fargate**: ~$30-50/month for small tasks
   - 2 vCPU / 4GB RAM for Playwright: ~$0.09/hour
   - FARGATE_SPOT can save 50-70%
4. **Vertex AI/Gemini**: ~$20-30/month (with caching)

### Cost-Saving Strategies
1. Use single NAT Gateway (not HA) in dev
2. Stop dev environment on weekends
3. Cache LLM responses aggressively
4. Use S3 + CloudFront instead of ALB where possible
5. Consider Lambda for scrapers vs ECS

---

## Monthly Review Checklist

- [ ] Check AWS Cost Explorer
- [ ] Review unused resources
- [ ] Verify free tier usage
- [ ] Check for unexpected charges
- [ ] Update cost projections
- [ ] Optimize if over budget

---

## Billing Alerts Setup

```bash
# Set these up immediately after account creation:
1. $10 alert - First warning
2. $50 alert - Development budget limit  
3. $100 alert - Investigate immediately
4. $200 alert - Potential issue
5. $400 alert - Near production budget
```
