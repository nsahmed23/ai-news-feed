#!/usr/bin/env python3
"""
AI Updates Tracker Architecture Diagram
Generates a visual architecture diagram for the AWS infrastructure
Using correct node classes from the diagrams library
"""

from diagrams import Cluster, Diagram, Edge
# AWS imports
from diagrams.aws.compute import EC2, ECS, Fargate, Lambda
from diagrams.aws.database import Dynamodb, ElasticacheForRedis
from diagrams.aws.integration import SQS, SNS
from diagrams.aws.management import Cloudwatch, SystemsManager, Cloudtrail, Config as AWSConfig
from diagrams.aws.network import ALB, CloudFront, Route53, VPC, InternetGateway
from diagrams.aws.security import IAM, KMS, SecretsManager, Guardduty, SecurityHub, WAF
from diagrams.aws.storage import S3
from diagrams.aws.cost import CostExplorer, Budgets
from diagrams.aws.ml import Sagemaker

# OnPrem imports
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.onprem.container import Docker
from diagrams.onprem.security import Trivy

# Programming imports
from diagrams.programming.framework import FastAPI
from diagrams.programming.language import Python

# Generic imports
from diagrams.generic.blank import Blank
from diagrams.generic.database import SQL

# SaaS imports
from diagrams.saas.logging import Datadog
from diagrams.saas.alerting import Pagerduty

# Graph attributes for better layout
graph_attr = {
    "fontsize": "16",
    "bgcolor": "white",
    "layout": "dot",
    "compound": "true",
    "splines": "ortho",
    "nodesep": "0.8",
    "ranksep": "1.0",
    "fontname": "Arial"
}

node_attr = {
    "fontsize": "12",
    "fontname": "Arial"
}

with Diagram("AI Updates Tracker - Production Architecture", 
             show=False, 
             filename="ai_updates_tracker_architecture",
             direction="TB",
             graph_attr=graph_attr,
             node_attr=node_attr):
    
    # External sources
    with Cluster("External Data Sources"):
        sources = [
            Internet("OpenAI RSS"),
            Internet("Anthropic API"),
            Github("GitHub Releases"),
            Internet("Web Scraping")
        ]
    
    # Users
    users = Users("End Users")
    
    # Edge Layer
    with Cluster("Edge Layer"):
        cdn = CloudFront("CDN\n(Static Assets)")
        dns = Route53("Route 53\n(DNS)")
        waf = WAF("Web Application\nFirewall")
    
    # Main VPC
    with Cluster("VPC (10.0.0.0/16)", graph_attr={"bgcolor": "lightblue"}):
        
        # Internet Gateway
        igw = InternetGateway("Internet Gateway")
        
        # Public Subnets
        with Cluster("Public Subnets"):
            with Cluster("AZ-1 (10.0.1.0/24)"):
                nat1 = EC2("NAT Instance\n(t3.small)")
            with Cluster("AZ-2 (10.0.2.0/24)"):
                nat2 = EC2("NAT Instance\n(Failover)")
            
            alb = ALB("Application\nLoad Balancer")
        
        # Private Subnets - Application Layer
        with Cluster("Private Subnets - App Layer"):
            with Cluster("ECS Fargate Cluster"):
                # API Service with FastAPI
                with Cluster("API Service"):
                    api_framework = FastAPI("FastAPI")
                    api_tasks = [
                        Fargate("API Task 1\n(FARGATE_SPOT)"),
                        Fargate("API Task 2\n(FARGATE_SPOT)")
                    ]
                
                # Background Workers
                with Cluster("Background Workers"):
                    worker_code = Python("Python Workers")
                    workers = [
                        Fargate("Worker 1\n(FARGATE_SPOT)"),
                        Fargate("Worker 2\n(FARGATE_SPOT)"),
                        Fargate("Worker 3\n(FARGATE_SPOT)")
                    ]
                
                webhook = Fargate("Webhook Handler\n(FARGATE)")
        
        # Private Subnets - Data Layer
        with Cluster("Private Subnets - Data Layer"):
            # Databases
            dynamodb = Dynamodb("DynamoDB\n(On-Demand)")
            redis = ElasticacheForRedis("Redis Cache\n(t3.micro)")
            
            # Storage
            with Cluster("S3 Buckets"):
                s3_raw = S3("Raw Data")
                s3_processed = S3("Processed")
                s3_static = S3("Static Assets")
        
        # VPC Endpoints
        with Cluster("VPC Endpoints"):
            vpc_endpoints = VPC("Gateway & Interface\nEndpoints")
    
    # Supporting Services
    with Cluster("Supporting Services"):
        # Security
        with Cluster("Security"):
            kms = KMS("KMS\n(Encryption)")
            secrets = SecretsManager("Secrets\nManager")
            guardduty = Guardduty("GuardDuty")
            security_hub = SecurityHub("Security Hub")
            iam = IAM("IAM Roles\n& Policies")
        
        # Monitoring & Logging
        with Cluster("Monitoring & Logging"):
            cloudwatch = Cloudwatch("CloudWatch\nLogs/Metrics")
            cloudtrail = Cloudtrail("CloudTrail\n(Audit)")
            config = AWSConfig("AWS Config\n(Compliance)")
        
        # Automation
        with Cluster("Automation"):
            lambda_funcs = [
                Lambda("Data Fetcher"),
                Lambda("Cost Monitor"),
                Lambda("Auto Shutdown")
            ]
            ssm = SystemsManager("Systems Manager\n(Runbooks)")
        
        # Cost Management
        with Cluster("Cost Management"):
            cost_explorer = CostExplorer("Cost Explorer")
            budgets = Budgets("Budget Alerts")
    
    # CI/CD Pipeline
    with Cluster("CI/CD Pipeline"):
        github = Github("GitHub\nRepository")
        actions = GithubActions("GitHub\nActions")
        docker = Docker("Docker\nBuild")
        trivy_scan = Trivy("Security\nScanning")
    
    # External Monitoring (Optional)
    with Cluster("External Services (Optional)"):
        datadog = Datadog("Datadog\n(APM)")
        pagerduty = Pagerduty("PagerDuty\n(Alerts)")
    
    # Data Flow - External to Application
    users >> Edge(color="darkgreen", style="bold") >> dns
    dns >> waf >> cdn >> alb
    
    # NAT Instance connections
    sources >> Edge(label="RSS/API", color="blue") >> igw >> nat1
    sources >> Edge(color="blue", style="dashed") >> igw >> nat2
    
    # ALB to Services
    alb >> Edge(color="darkgreen") >> api_tasks
    alb >> Edge(color="orange") >> webhook
    
    # API Framework integration
    api_framework >> Edge(color="purple", style="dashed") >> api_tasks
    worker_code >> Edge(color="purple", style="dashed") >> workers
    
    # Internal Service Communication
    api_tasks >> Edge(color="brown") >> redis
    api_tasks >> Edge(color="black") >> dynamodb
    webhook >> Edge(color="purple") >> workers
    
    # Workers to Data Stores
    workers >> Edge(label="process", color="blue") >> s3_processed
    workers >> Edge(color="black") >> dynamodb
    
    # Lambda Functions
    lambda_funcs[0] >> Edge(label="fetch", color="blue") >> sources
    lambda_funcs[0] >> Edge(label="store", color="green") >> s3_raw
    lambda_funcs[1] >> Edge(label="monitor", color="orange") >> cost_explorer
    lambda_funcs[2] >> Edge(label="shutdown", color="red", style="dashed") >> workers
    
    # Security Services
    kms >> Edge(label="encrypt", color="red", style="dashed") >> [dynamodb, s3_raw, s3_processed]
    secrets >> Edge(label="credentials", color="purple", style="dashed") >> api_tasks
    iam >> Edge(label="assume role", color="orange", style="dashed") >> [api_tasks, workers, lambda_funcs]
    
    # Monitoring
    [api_tasks, workers, webhook] >> Edge(label="logs", color="gray", style="dotted") >> cloudwatch
    guardduty >> Edge(color="red", style="dashed") >> security_hub
    cloudtrail >> Edge(label="audit", color="blue", style="dotted") >> s3_raw
    
    # Cost Monitoring
    cost_explorer >> Edge(color="green", style="dashed") >> budgets
    
    # CI/CD Flow
    github >> Edge(label="trigger", color="darkblue") >> actions
    actions >> Edge(label="build", color="darkblue") >> docker
    docker >> Edge(label="scan", color="red") >> trivy_scan
    trivy_scan >> Edge(label="deploy", color="darkblue", style="bold") >> api_tasks
    
    # CDN to S3
    cdn >> Edge(color="lightblue", style="dotted") >> s3_static
    
    # VPC Endpoints
    vpc_endpoints >> Edge(label="private access", color="purple", style="dotted") >> [s3_raw, s3_processed, dynamodb]
    
    # External Monitoring (Optional)
    cloudwatch >> Edge(label="export", color="gray", style="dashed") >> datadog
    cloudwatch >> Edge(label="alerts", color="red", style="dashed") >> pagerduty


# Generate additional diagrams for specific aspects

# Cost Optimization Diagram
with Diagram("AI Updates Tracker - Cost Optimization", 
             show=False, 
             filename="ai_updates_cost_optimization",
             direction="LR"):
    
    with Cluster("Cost Optimization Strategies"):
        with Cluster("Network Costs"):
            nat_instance = EC2("NAT Instance\n$14.60/month")
            nat_gateway = InternetGateway("NAT Gateway\n$37.35/month")
            nat_instance >> Edge(label="Save $22.75", color="green", style="bold") >> nat_gateway
        
        with Cluster("Compute Costs"):
            fargate_spot = Fargate("Fargate Spot\n70% savings")
            fargate_regular = Fargate("Fargate Regular")
            fargate_spot >> Edge(label="Save 70%", color="green", style="bold") >> fargate_regular
        
        with Cluster("Storage Costs"):
            s3_lifecycle = S3("S3 + Lifecycle\n$10-15/month")
            dynamodb_ondemand = Dynamodb("DynamoDB\nOn-Demand")
        
        with Cluster("Schedule-based"):
            scheduler = Lambda("Auto Shutdown\nNon-Prod")
            dev_env = ECS("Dev Environment")
            scheduler >> Edge(label="Stop 6PM-9AM", color="red") >> dev_env


# Security Architecture Diagram
with Diagram("AI Updates Tracker - Security Architecture", 
             show=False, 
             filename="ai_updates_security",
             direction="TB"):
    
    with Cluster("Security Layers"):
        with Cluster("Network Security"):
            vpc_security = VPC("Private VPC")
            sg = WAF("WAF +\nSecurity Groups")
            nacl = InternetGateway("NACLs +\nIGW Controls")
        
        with Cluster("Data Security"):
            kms_keys = KMS("KMS Keys\n(Account-Scoped)")
            encryption = SecretsManager("Secrets Manager\n+ Encryption")
        
        with Cluster("Access Control"):
            iam = IAM("Progressive IAM\nPermissions")
            secrets_mgr = SecretsManager("Secrets Manager")
        
        with Cluster("Monitoring & Compliance"):
            trail = Cloudtrail("CloudTrail")
            config = AWSConfig("AWS Config")
            guard = Guardduty("GuardDuty")
            hub = SecurityHub("Security Hub")
    
    # Security Flow
    iam >> Edge(label="Week 1", color="green") >> Blank("S3, DynamoDB, KMS only")
    iam >> Edge(label="Week 3", color="orange") >> Blank("+ ECS, ECR")
    iam >> Edge(label="Week 5", color="red") >> Blank("+ Lambda, CloudWatch")
    
    [trail, config, guard] >> Edge(color="blue", style="dashed") >> hub


# Data Pipeline Diagram
with Diagram("AI Updates Tracker - Data Pipeline", 
             show=False, 
             filename="ai_updates_data_pipeline",
             direction="LR"):
    
    # Sources
    with Cluster("Data Sources"):
        rss_feeds = Internet("RSS Feeds")
        apis = Internet("APIs")
        webhooks = Internet("Webhooks")
    
    # Ingestion
    with Cluster("Data Ingestion"):
        fetcher = Lambda("Scheduled\nFetcher")
        webhook_handler = Fargate("Webhook\nHandler")
        queue = SQS("Processing\nQueue")
    
    # Processing
    with Cluster("Data Processing"):
        processor = Fargate("Data\nProcessor")
        ml_enrichment = Sagemaker("ML\nEnrichment")
    
    # Storage
    with Cluster("Data Storage"):
        raw = S3("Raw Data\nLake")
        processed = S3("Processed\nData")
        db = Dynamodb("Updates\nDatabase")
    
    # Serving
    with Cluster("Data Serving"):
        api = Fargate("API\nService")
        cache = ElasticacheForRedis("Redis\nCache")
    
    # Data Flow
    [rss_feeds, apis] >> Edge(label="poll", color="blue") >> fetcher
    webhooks >> Edge(label="push", color="green") >> webhook_handler
    
    fetcher >> Edge(label="queue", color="orange") >> queue
    webhook_handler >> Edge(label="queue", color="orange") >> queue
    
    queue >> Edge(label="consume", color="purple") >> processor
    processor >> Edge(label="enrich", color="red") >> ml_enrichment
    
    processor >> Edge(label="archive", color="gray") >> raw
    ml_enrichment >> Edge(label="store", color="green") >> processed
    ml_enrichment >> Edge(label="index", color="blue") >> db
    
    db >> Edge(label="query", color="darkgreen") >> api
    api >> Edge(label="cache", color="brown") >> cache