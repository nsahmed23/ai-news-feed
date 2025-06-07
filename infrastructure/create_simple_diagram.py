#!/usr/bin/env python3
"""
AI Updates Tracker - Infrastructure Visualization
A simplified architecture diagram using matplotlib
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Rectangle, FancyArrowPatch
import matplotlib.lines as mlines

# Create figure and axis
fig, ax = plt.subplots(1, 1, figsize=(20, 16))
ax.set_xlim(0, 100)
ax.set_ylim(0, 100)
ax.axis('off')

# Define colors
color_network = '#FF9900'  # Orange for networking
color_compute = '#232F3E'  # Dark blue for compute
color_storage = '#569A31'  # Green for storage
color_security = '#DD344C' # Red for security
color_monitor = '#759EEA'  # Light blue for monitoring

# Title
plt.title('AI Updates Tracker - AWS Infrastructure Architecture\nJune 6, 2025', 
          fontsize=24, fontweight='bold', pad=20)

# ========== VPC Box ==========
vpc_box = FancyBboxPatch((5, 25), 90, 65, 
                         boxstyle="round,pad=0.1",
                         facecolor='#FFE5B4',
                         edgecolor=color_network,
                         linewidth=3)
ax.add_patch(vpc_box)
ax.text(50, 87, 'VPC (10.0.0.0/16)', fontsize=16, fontweight='bold', ha='center')

# Internet Gateway
igw = Rectangle((2, 55), 8, 10, facecolor=color_network, edgecolor='black', linewidth=2)
ax.add_patch(igw)
ax.text(6, 60, 'IGW', fontsize=10, ha='center', va='center', fontweight='bold')

# ========== Public Subnets ==========
# Public Subnet 1
pub1 = FancyBboxPatch((15, 65), 35, 20, 
                      boxstyle="round,pad=0.05",
                      facecolor='#E8F5E9',
                      edgecolor=color_network,
                      linewidth=2)
ax.add_patch(pub1)
ax.text(32.5, 78, 'Public Subnet 1', fontsize=12, ha='center')
ax.text(32.5, 74, '10.0.1.0/24 (us-east-1a)', fontsize=9, ha='center')

# NAT Gateway
nat = Rectangle((25, 67), 15, 6, facecolor=color_network, edgecolor='black', linewidth=2)
ax.add_patch(nat)
ax.text(32.5, 70, 'NAT Gateway', fontsize=10, ha='center', va='center', fontweight='bold')

# Public Subnet 2
pub2 = FancyBboxPatch((55, 65), 35, 20, 
                      boxstyle="round,pad=0.05",
                      facecolor='#E8F5E9',
                      edgecolor=color_network,
                      linewidth=2)
ax.add_patch(pub2)
ax.text(72.5, 78, 'Public Subnet 2', fontsize=12, ha='center')
ax.text(72.5, 74, '10.0.2.0/24 (us-east-1b)', fontsize=9, ha='center')

# ========== Private Subnets ==========
# Private Subnet 1
priv1 = FancyBboxPatch((15, 40), 35, 20, 
                       boxstyle="round,pad=0.05",
                       facecolor='#FFEBEE',
                       edgecolor=color_network,
                       linewidth=2)
ax.add_patch(priv1)
ax.text(32.5, 53, 'Private Subnet 1', fontsize=12, ha='center')
ax.text(32.5, 49, '10.0.11.0/24 (us-east-1a)', fontsize=9, ha='center')

# Private Subnet 2
priv2 = FancyBboxPatch((55, 40), 35, 20, 
                       boxstyle="round,pad=0.05",
                       facecolor='#FFEBEE',
                       edgecolor=color_network,
                       linewidth=2)
ax.add_patch(priv2)
ax.text(72.5, 53, 'Private Subnet 2', fontsize=12, ha='center')
ax.text(72.5, 49, '10.0.12.0/24 (us-east-1b)', fontsize=9, ha='center')

# ========== Container Services ==========
# ECS Cluster
ecs = FancyBboxPatch((25, 44), 20, 12, 
                     boxstyle="round,pad=0.05",
                     facecolor=color_compute,
                     edgecolor='black',
                     linewidth=2)
ax.add_patch(ecs)
ax.text(35, 50, 'ECS Cluster', fontsize=11, ha='center', va='center', color='white', fontweight='bold')

# ECR
ecr = FancyBboxPatch((60, 44), 20, 12, 
                     boxstyle="round,pad=0.05",
                     facecolor=color_compute,
                     edgecolor='black',
                     linewidth=2)
ax.add_patch(ecr)
ax.text(70, 50, 'ECR', fontsize=11, ha='center', va='center', color='white', fontweight='bold')

# ========== Storage ==========
# S3 Buckets
s3_scraped = FancyBboxPatch((15, 28), 25, 8, 
                            boxstyle="round,pad=0.05",
                            facecolor=color_storage,
                            edgecolor='black',
                            linewidth=2)
ax.add_patch(s3_scraped)
ax.text(27.5, 32, 'S3: Scraped Data', fontsize=10, ha='center', va='center', color='white')

s3_static = FancyBboxPatch((45, 28), 25, 8, 
                           boxstyle="round,pad=0.05",
                           facecolor=color_storage,
                           edgecolor='black',
                           linewidth=2)
ax.add_patch(s3_static)
ax.text(57.5, 32, 'S3: Static Website', fontsize=10, ha='center', va='center', color='white')

s3_terraform = FancyBboxPatch((75, 28), 15, 8, 
                              boxstyle="round,pad=0.05",
                              facecolor=color_storage,
                              edgecolor='black',
                              linewidth=2)
ax.add_patch(s3_terraform)
ax.text(82.5, 32, 'S3: TF State', fontsize=9, ha='center', va='center', color='white')

# ========== Security & Monitoring ==========
# CloudTrail
cloudtrail = FancyBboxPatch((5, 12), 18, 8, 
                            boxstyle="round,pad=0.05",
                            facecolor=color_security,
                            edgecolor='black',
                            linewidth=2)
ax.add_patch(cloudtrail)
ax.text(14, 16, 'CloudTrail', fontsize=10, ha='center', va='center', color='white', fontweight='bold')

# Config
config = FancyBboxPatch((26, 12), 18, 8, 
                        boxstyle="round,pad=0.05",
                        facecolor=color_security,
                        edgecolor='black',
                        linewidth=2)
ax.add_patch(config)
ax.text(35, 16, 'Config (6 rules)', fontsize=10, ha='center', va='center', color='white', fontweight='bold')

# CloudWatch
cloudwatch = FancyBboxPatch((47, 12), 20, 8, 
                            boxstyle="round,pad=0.05",
                            facecolor=color_monitor,
                            edgecolor='black',
                            linewidth=2)
ax.add_patch(cloudwatch)
ax.text(57, 16, 'CloudWatch', fontsize=10, ha='center', va='center', fontweight='bold')

# SNS
sns = FancyBboxPatch((70, 12), 20, 8, 
                     boxstyle="round,pad=0.05",
                     facecolor=color_security,
                     edgecolor='black',
                     linewidth=2)
ax.add_patch(sns)
ax.text(80, 16, 'SNS Alerts', fontsize=10, ha='center', va='center', color='white', fontweight='bold')

# ========== External ==========
# Users
users = FancyBboxPatch((40, 95), 20, 4, 
                       boxstyle="round,pad=0.05",
                       facecolor='lightgray',
                       edgecolor='black',
                       linewidth=2)
ax.add_patch(users)
ax.text(50, 97, 'End Users', fontsize=11, ha='center', va='center', fontweight='bold')

# ========== Arrows and Connections ==========
# Users to IGW
ax.arrow(50, 95, 0, -30, head_width=1, head_length=1, fc='black', ec='black')
ax.arrow(10, 65, 0, -5, head_width=1, head_length=1, fc='black', ec='black')

# NAT to IGW
ax.plot([25, 10], [70, 60], 'k--', linewidth=1)

# ECS to Subnets
ax.plot([35, 32.5], [44, 40], 'k--', linewidth=1, alpha=0.5)
ax.plot([35, 72.5], [44, 40], 'k--', linewidth=1, alpha=0.5)

# Security monitoring connections
ax.plot([14, 35], [20, 28], 'r--', linewidth=1, alpha=0.5)
ax.plot([35, 35], [20, 28], 'r--', linewidth=1, alpha=0.5)
ax.plot([57, 57], [20, 28], 'b--', linewidth=1, alpha=0.5)

# ========== Legend ==========
legend_elements = [
    mlines.Line2D([0], [0], color=color_network, lw=4, label='Networking'),
    mlines.Line2D([0], [0], color=color_compute, lw=4, label='Compute'),
    mlines.Line2D([0], [0], color=color_storage, lw=4, label='Storage'),
    mlines.Line2D([0], [0], color=color_security, lw=4, label='Security'),
    mlines.Line2D([0], [0], color=color_monitor, lw=4, label='Monitoring')
]
ax.legend(handles=legend_elements, loc='lower left', fontsize=12)

# ========== Key Information Box ==========
info_text = """Key Infrastructure Components:
• VPC with 2 public and 2 private subnets
• NAT Gateway for outbound internet (3.219.107.20)
• ECS Cluster + ECR for containerized workloads
• 5 S3 buckets (data, static site, CloudTrail, Config, Terraform)
• CloudTrail audit logging + 6 Config compliance rules
• CloudWatch logging + monitoring dashboard
• SNS email alerts to nsahmed23@gmail.com
• 4 Security Groups (ALB, ECS, Lambda, VPC Endpoints)
• VPC Flow Logs enabled"""

info_box = FancyBboxPatch((2, 0), 40, 10, 
                          boxstyle="round,pad=0.1",
                          facecolor='lightyellow',
                          edgecolor='black',
                          linewidth=1)
ax.add_patch(info_box)
ax.text(3, 5, info_text, fontsize=9, va='center')

# Save the diagram
plt.tight_layout()
plt.savefig('infrastructure_architecture.png', dpi=300, bbox_inches='tight', facecolor='white')
plt.savefig('infrastructure_architecture.pdf', bbox_inches='tight', facecolor='white')

print("\nArchitecture diagram created successfully!")
print("Output files:")
print("- infrastructure_architecture.png")
print("- infrastructure_architecture.pdf")
print("\nThis diagram shows all the AWS infrastructure components")
print("deployed during Days 2-7 of your AI Updates Tracker project.")
