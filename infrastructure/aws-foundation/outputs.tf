# Output values for use by other modules

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = data.aws_availability_zones.available.names
}

output "vpc_flow_logs_group" {
  description = "CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}

output "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  value       = aws_security_group.lambda.id
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the VPC endpoints security group"
  value       = aws_security_group.vpc_endpoints.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = var.create_rds_sg ? aws_security_group.rds[0].id : null
}

# S3 Bucket Outputs
output "scraped_data_bucket_name" {
  description = "Name of the scraped data S3 bucket"
  value       = module.scraped_data_bucket.bucket_id
}

output "scraped_data_bucket_arn" {
  description = "ARN of the scraped data S3 bucket"
  value       = module.scraped_data_bucket.bucket_arn
}

output "static_assets_bucket_name" {
  description = "Name of the static assets S3 bucket"
  value       = module.static_assets_bucket.bucket_id
}

output "static_assets_bucket_arn" {
  description = "ARN of the static assets S3 bucket"
  value       = module.static_assets_bucket.bucket_arn
}

output "static_assets_bucket_website_endpoint" {
  description = "Website endpoint for the static assets bucket"
  value       = module.static_assets_bucket.website_endpoint
}

output "terraform_state_bucket_name" {
  description = "Name of the Terraform state S3 bucket"
  value       = var.create_terraform_state_bucket ? module.terraform_state_bucket[0].bucket_id : null
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  value       = var.create_terraform_state_bucket ? module.terraform_state_bucket[0].bucket_arn : null
}

output "dynamodb_state_lock_table" {
  description = "Name of the DynamoDB table for Terraform state locking"
  value       = var.create_terraform_state_bucket ? aws_dynamodb_table.terraform_locks[0].name : null
}

# S3 access is now handled by inline policy on ECS task role
