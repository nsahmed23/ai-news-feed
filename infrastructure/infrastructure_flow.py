#!/usr/bin/env python3
"""
AI Updates Tracker - Data Flow Visualization
Shows how data flows through the infrastructure
"""

def print_header(text):
    print(f"\n{'='*60}")
    print(f"  {text}")
    print('='*60)

def print_step(number, description, detail=""):
    print(f"\n{number}. {description}")
    if detail:
        print(f"   └─► {detail}")

print_header("AI UPDATES TRACKER - INFRASTRUCTURE DATA FLOW")
print("\nDeployed on: June 6, 2025")
print("AWS Account: 279684395806")
print("Region: us-east-1")

# ========== SCRAPING FLOW ==========
print_header("WEB SCRAPING DATA FLOW")

print_step("1", "Trigger: CloudWatch Events (Schedule)", 
           "Every 2 hours → Lambda/ECS Task")

print_step("2", "Scraper Execution",
           "ECS Task in Private Subnet (10.0.11.0/24)")

print_step("3", "Internet Access", 
           "ECS → NAT Gateway (3.219.107.20) → Internet Gateway → Web")

print_step("4", "Data Collection",
           "Scraper fetches updates from AI company websites/RSS feeds")

print_step("5", "Data Storage",
           "Processed data → S3 bucket (ai-news-feed-development-scraped-data-991el7cv)")

print_step("6", "Logging",
           "Logs → CloudWatch (/aws/scrapers/ai-updates-tracker-development)")

# ========== API FLOW ==========
print_header("API SERVICE DATA FLOW")

print_step("1", "User Request",
           "Internet → Route 53 (DNS)")

print_step("2", "Load Balancer",
           "ALB in Public Subnets (10.0.1.0/24, 10.0.2.0/24)")

print_step("3", "API Service",
           "ALB → ECS Tasks in Private Subnets")

print_step("4", "Data Retrieval",
           "ECS Task → S3 (Read scraped data)")

print_step("5", "Response",
           "ECS → ALB → Internet Gateway → User")

# ========== STATIC WEBSITE FLOW ==========
print_header("STATIC WEBSITE FLOW")

print_step("1", "User visits website",
           "Browser → ai-news-feed-development-static-assets-991el7cv.s3-website-us-east-1.amazonaws.com")

print_step("2", "S3 serves static files",
           "HTML, CSS, JavaScript directly from S3")

print_step("3", "API calls from frontend",
           "JavaScript → API endpoint (via ALB)")

# ========== SECURITY MONITORING FLOW ==========
print_header("SECURITY & COMPLIANCE MONITORING")

print_step("1", "CloudTrail",
           "All API calls → CloudTrail → S3 + CloudWatch Logs")

print_step("2", "AWS Config", 
           "Resource compliance → 6 Config Rules → SNS Alerts")

print_step("3", "VPC Flow Logs",
           "Network traffic → CloudWatch Logs")

print_step("4", "Alerts",
           "Critical events → SNS → Email (nsahmed23@gmail.com)")

# ========== INFRASTRUCTURE COMPONENTS ==========
print_header("DEPLOYED INFRASTRUCTURE COMPONENTS")

components = {
    "Networking": [
        "VPC: 10.0.0.0/16",
        "Public Subnets: 10.0.1.0/24, 10.0.2.0/24",
        "Private Subnets: 10.0.11.0/24, 10.0.12.0/24",
        "Internet Gateway: igw-080bc24458ec059ce",
        "NAT Gateway: nat-02749ae1ed873af21 (3.219.107.20)"
    ],
    "Compute": [
        "ECS Cluster: ai-updates-tracker-development-cluster",
        "ECR Repository: ai-news-feed-development",
        "Task Roles: ECS Task Role, ECS Execution Role"
    ],
    "Storage": [
        "S3: Scraped Data (private)",
        "S3: Static Website (public)",
        "S3: CloudTrail Logs",
        "S3: Config Data",
        "S3: Terraform State"
    ],
    "Security": [
        "4 Security Groups (ALB, ECS, Lambda, VPC Endpoints)",
        "CloudTrail: Audit logging enabled",
        "Config: 6 compliance rules active",
        "VPC Flow Logs: Network monitoring",
        "SNS: Email alerts configured"
    ],
    "Monitoring": [
        "CloudWatch Dashboard",
        "5 Log Groups",
        "CPU High Alarm (>80%)",
        "Custom metrics ready"
    ]
}

for category, items in components.items():
    print(f"\n{category}:")
    for item in items:
        print(f"  • {item}")

# ========== COSTS ==========
print_header("ESTIMATED DAILY COSTS")

costs = [
    ("NAT Gateway", "$1.08 + data transfer"),
    ("S3 Storage", "$0.10-0.20"),
    ("CloudTrail", "$0.10"),
    ("Config Rules", "$0.20"),
    ("CloudWatch", "$0.50"),
    ("Total Baseline", "$2-3/day (before compute)")
]

for service, cost in costs:
    print(f"{service:.<30} {cost}")

print("\n" + "="*60)
print("Infrastructure ready for application deployment!")
print("Next: Build Lambda scrapers and ECS API services")
print("="*60 + "\n")
