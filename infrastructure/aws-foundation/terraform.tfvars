# Development Environment Variables

aws_region  = "us-east-1"
environment = "development"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# Public subnets (for Load Balancers, NAT Gateway)
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Private subnets (for ECS tasks, Lambda functions)
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# DNS Configuration
enable_dns_hostnames = true
enable_dns_support   = true

# NAT Gateway Configuration
enable_nat_gateway = true
single_nat_gateway = true # Cost optimization - single NAT instead of HA
