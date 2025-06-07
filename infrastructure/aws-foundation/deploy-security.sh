#!/bin/bash
# Deploy essential security additions

echo "🔒 Deploying Essential Security Components..."

# Update email address
read -p "Enter your email for security alerts: " email
sed -i "s/your-email@example.com/$email/" security-additions.tf

echo "📋 Deploying additional Config rules..."
terraform apply -target=aws_config_config_rule.root_mfa -auto-approve
terraform apply -target=aws_config_config_rule.ebs_encryption -auto-approve
terraform apply -target=aws_config_config_rule.rds_encryption -auto-approve

echo "🔔 Setting up security alerts..."
terraform apply -target=aws_sns_topic.security_alerts -auto-approve
terraform apply -target=aws_sns_topic_subscription.security_alerts_email -auto-approve

echo "✅ Essential security components deployed!"
echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "1. Check your email and confirm the SNS subscription"
echo "2. Enable MFA on your AWS root account"
echo "3. Enable EBS encryption by default:"
echo "   aws ec2 enable-ebs-encryption-by-default --region us-east-1"
echo ""
echo "💰 Optional (adds cost):"
echo "- Uncomment GuardDuty in security-additions.tf (+$30-50/month)"
echo "- Uncomment Security Hub in security-additions.tf (+$10-20/month)"
