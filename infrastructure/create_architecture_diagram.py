#!/usr/bin/env python3
"""
AI Updates Tracker - AWS Infrastructure Architecture Diagram
Generated on June 6, 2025
This diagram shows all infrastructure components deployed in Days 2-7
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import ECS, ECR, Lambda
from diagrams.aws.network import VPC, PublicSubnet, PrivateSubnet, NATGateway, InternetGateway, Route53
from diagrams.aws.network import ALB, SecurityGroup
from diagrams.aws.storage import S3
from diagrams.aws.security import IAM, CloudTrail, Config, SecretsManager, SNS
from diagrams.aws.management import Cloudwatch, SystemsManager
from diagrams.aws.database import DynamoDB
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Github

# Create the diagram
with Diagram("AI Updates Tracker - AWS Infrastructure", 
             filename="infrastructure_diagram", 
             show=False,
             direction="TB",
             graph_attr={
                 "fontsize": "45",
                 "bgcolor": "white",
                 "pad": "0.5",
                 "nodesep": "0.7",
                 "ranksep": "2.0",
                 "splines": "ortho"
             }):
    
    # External users
    users = Users("End Users")
    
    # GitHub for Terraform state
    github = Github("GitHub\n(Code)")
    
    with Cluster("AWS Account (279684395806) - us-east-1"):
        
        # Terraform Backend
        with Cluster("Terraform State Management"):
            tf_state_bucket = S3("terraform-state\n-991el7cv")
            tf_lock_table = DynamoDB("terraform-locks")
        
        # Security & Compliance Layer
        with Cluster("Security & Compliance"):
            cloudtrail = CloudTrail("CloudTrail\nAudit Logging")
            config = Config("AWS Config\n6 Rules Active")
            sns_alerts = SNS("Security Alerts\nnsahmed23@gmail.com")
            
            # CloudTrail and Config S3 buckets
            cloudtrail_bucket = S3("cloudtrail-logs\n-991el7cv")
            config_bucket = S3("config-data\n-991el7cv")
            
            cloudtrail >> cloudtrail_bucket
            config >> config_bucket
            config >> sns_alerts
        
        # VPC Network Architecture
        with Cluster("VPC (10.0.0.0/16)"):
            igw = InternetGateway("Internet Gateway")
            
            with Cluster("Public Subnets"):
                pub_subnet_1 = PublicSubnet("Public-1\n10.0.1.0/24\nus-east-1a")
                pub_subnet_2 = PublicSubnet("Public-2\n10.0.2.0/24\nus-east-1b")
                nat_gw = NATGateway("NAT Gateway\n3.219.107.20")
                pub_subnet_1 - nat_gw
            
            with Cluster("Private Subnets"):
                priv_subnet_1 = PrivateSubnet("Private-1\n10.0.11.0/24\nus-east-1a")
                priv_subnet_2 = PrivateSubnet("Private-2\n10.0.12.0/24\nus-east-1b")
            
            # Security Groups
            with Cluster("Security Groups"):
                sg_alb = SecurityGroup("ALB SG\nsg-003188a58a3eb2680")
                sg_ecs = SecurityGroup("ECS Tasks SG\nsg-0c7528038e7759422")
                sg_lambda = SecurityGroup("Lambda SG\nsg-0b319e589a7cf06de")
                sg_endpoints = SecurityGroup("VPC Endpoints SG\nsg-043de2c4bc7bb32c8")
        
        # Container Infrastructure
        with Cluster("Container Services"):
            ecr = ECR("ECR Repository\nai-news-feed-dev")
            ecs_cluster = ECS("ECS Cluster\nai-updates-tracker-dev")
            ecr >> ecs_cluster
        
        # Application Storage
        with Cluster("Application Storage"):
            scraped_data = S3("Scraped Data\n-991el7cv\n(Private)")
            static_assets = S3("Static Assets\n-991el7cv\n(Public Website)")
        
        # Monitoring & Logging
        with Cluster("Observability"):
            cw_logs = Cloudwatch("CloudWatch Logs")
            cw_dashboard = Cloudwatch("CloudWatch\nDashboard")
            
            # Log Groups
            log_groups = [
                "/ecs/ai-updates-tracker",
                "/aws/application/ai-updates-tracker",
                "/aws/scrapers/ai-updates-tracker",
                "/aws/vpc/flow-logs",
                "/aws/cloudtrail/ai-updates-tracker"
            ]
        
        # IAM Roles
        with Cluster("IAM Roles"):
            iam_ecs_task = IAM("ECS Task Role")
            iam_ecs_exec = IAM("ECS Task\nExecution Role")
            iam_cloudtrail = IAM("CloudTrail Role")
            iam_config = IAM("Config Role")
            iam_flow_logs = IAM("VPC Flow\nLogs Role")
    
    # ==================
    # Connections
    # ==================
    
    # User traffic flow
    users >> Edge(label="HTTPS", style="bold") >> static_assets
    users >> Edge(label="API Calls") >> igw
    
    # Network flow
    igw >> pub_subnet_1
    igw >> pub_subnet_2
    nat_gw >> Edge(label="Outbound", style="dashed") >> igw
    priv_subnet_1 >> Edge(label="Internet", style="dashed") >> nat_gw
    priv_subnet_2 >> Edge(label="Internet", style="dashed") >> nat_gw
    
    # ECS Tasks in private subnets
    ecs_cluster >> priv_subnet_1
    ecs_cluster >> priv_subnet_2
    
    # Security group connections
    sg_alb >> sg_ecs
    sg_ecs >> scraped_data
    sg_lambda >> scraped_data
    
    # Monitoring connections
    ecs_cluster >> Edge(label="Logs", style="dotted") >> cw_logs
    cloudtrail >> Edge(label="Logs", style="dotted") >> cw_logs
    cw_logs >> cw_dashboard
    
    # Terraform state
    github >> Edge(label="terraform apply", color="darkgreen") >> tf_state_bucket
    github >> Edge(label="state lock", color="darkgreen") >> tf_lock_table
    
    # Compliance monitoring
    config >> Edge(label="monitors", style="dotted") >> ecs_cluster
    config >> Edge(label="monitors", style="dotted") >> scraped_data
    config >> Edge(label="monitors", style="dotted") >> static_assets

print("\nArchitecture diagram created successfully!")
print("Output file: infrastructure_diagram.png")
print("\nKey Components:")
print("- VPC with public/private subnets across 2 AZs")
print("- NAT Gateway for outbound internet access")
print("- ECS Cluster with ECR for container deployments")
print("- S3 buckets for data storage and static website")
print("- Comprehensive security with CloudTrail, Config, and SNS alerts")
print("- CloudWatch for monitoring and logging")
print("- Terraform state management with S3 and DynamoDB")
