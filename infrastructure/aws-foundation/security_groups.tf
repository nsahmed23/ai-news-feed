# security_groups.tf
# Security Groups for AI Updates Tracker
# AUT-003: Security Groups Implementation
# Created: June 7, 2025

# --------------------------------------------------------------------------
# Application Load Balancer Security Group
# --------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Inbound: HTTP from internet
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound: HTTPS from internet
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: All traffic (will be restricted to ECS later)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb-sg"
    Type = "ALB"
  })
}

# --------------------------------------------------------------------------
# ECS Tasks Security Group
# --------------------------------------------------------------------------
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Security group for ECS tasks running web scrapers"
  vpc_id      = aws_vpc.main.id

  # Outbound: HTTPS to internet for API calls and web scraping
  egress {
    description = "HTTPS to internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: HTTP for some websites
  egress {
    description = "HTTP to internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: DNS
  egress {
    description = "DNS resolution"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: DNS over TCP
  egress {
    description = "DNS resolution TCP"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-tasks-sg"
    Type = "ECS"
  })
}

# Rule to allow inbound traffic from ALB to ECS tasks
resource "aws_security_group_rule" "ecs_from_alb" {
  type                     = "ingress"
  description              = "Allow inbound traffic from ALB"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs_tasks.id
}

# --------------------------------------------------------------------------
# Lambda Functions Security Group
# --------------------------------------------------------------------------
resource "aws_security_group" "lambda" {
  name        = "${var.project_name}-lambda-sg"
  description = "Security group for Lambda functions"
  vpc_id      = aws_vpc.main.id

  # Lambda functions only need outbound rules
  # Outbound: HTTPS for API calls
  egress {
    description = "HTTPS to internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: HTTP for some APIs
  egress {
    description = "HTTP to internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: DNS
  egress {
    description = "DNS resolution"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-lambda-sg"
    Type = "Lambda"
  })
}

# --------------------------------------------------------------------------
# VPC Endpoints Security Group
# --------------------------------------------------------------------------
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}-vpce-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  # Inbound: HTTPS from VPC CIDR
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpce-sg"
    Type = "VPC-Endpoints"
  })
}

# --------------------------------------------------------------------------
# RDS Security Group (Prepared for future use)
# --------------------------------------------------------------------------
resource "aws_security_group" "rds" {
  count = var.create_rds_sg ? 1 : 0

  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS PostgreSQL database"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-sg"
    Type = "RDS"
  })
}

# Rule to allow PostgreSQL access from ECS tasks
resource "aws_security_group_rule" "rds_from_ecs" {
  count = var.create_rds_sg ? 1 : 0

  type                     = "ingress"
  description              = "PostgreSQL from ECS tasks"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_tasks.id
  security_group_id        = aws_security_group.rds[0].id
}

# Rule to allow PostgreSQL access from Lambda
resource "aws_security_group_rule" "rds_from_lambda" {
  count = var.create_rds_sg ? 1 : 0

  type                     = "ingress"
  description              = "PostgreSQL from Lambda functions"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
  security_group_id        = aws_security_group.rds[0].id
}


