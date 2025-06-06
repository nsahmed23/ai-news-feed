# AWS Foundation Infrastructure

This directory contains the Terraform configuration for the base AWS infrastructure for the AI Updates Tracker project.

## Architecture

- **VPC**: 10.0.0.0/16 CIDR block
- **Public Subnets**: 2 subnets (10.0.1.0/24, 10.0.2.0/24) across 2 AZs
- **Private Subnets**: 2 subnets (10.0.11.0/24, 10.0.12.0/24) across 2 AZs
- **NAT Gateway**: Single NAT Gateway for cost optimization
- **Internet Gateway**: For public subnet internet access
- **VPC Flow Logs**: CloudWatch logging for network monitoring

## Cost Optimization Decisions

1. **Single NAT Gateway**: Using one NAT Gateway instead of HA pair saves ~$45/month
2. **VPC Flow Logs**: 7-day retention to minimize CloudWatch costs
3. **Region**: us-east-1 typically has the lowest prices

## Files

- `providers.tf` - AWS provider configuration
- `variables.tf` - Input variable definitions
- `vpc.tf` - VPC and networking resources
- `outputs.tf` - Output values for other modules
- `terraform.tfvars` - Variable values for development environment

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Destroy resources (when needed)
terraform destroy
```

## Estimated Costs

- VPC: $0/month (free)
- Subnets: $0/month (free)
- Internet Gateway: $0/month (free)
- NAT Gateway: ~$32/month ($0.045/hour)
- VPC Flow Logs: ~$5/month (depending on traffic)
- **Total**: ~$37/month

## Next Steps

After the VPC is created, we'll add:
1. Security Groups (AUT-003)
2. ECS Cluster (AUT-004)
3. S3 Buckets (AUT-005)
4. And more...
