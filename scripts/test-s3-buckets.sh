#!/bin/bash
# Test script for S3 buckets deployment
# Run this after terraform apply to verify everything works

set -e

echo "🧪 Testing S3 Buckets Implementation..."
echo "======================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Change to terraform directory to get outputs
cd "$(dirname "$0")/../infrastructure/aws-foundation" || exit 1

# Get bucket names from Terraform outputs
SCRAPED_BUCKET=$(terraform output -raw scraped_data_bucket_name 2>/dev/null || echo "")
STATIC_BUCKET=$(terraform output -raw static_assets_bucket_name 2>/dev/null || echo "")
WEBSITE_ENDPOINT=$(terraform output -raw static_assets_bucket_website_endpoint 2>/dev/null || echo "")

if [ -z "$SCRAPED_BUCKET" ] || [ -z "$STATIC_BUCKET" ]; then
    echo -e "${RED}❌ Error: Could not get bucket names from Terraform outputs${NC}"
    echo "Make sure you have run 'terraform apply' first"
    exit 1
fi

echo "📦 Buckets found:"
echo "  - Scraped Data: $SCRAPED_BUCKET"
echo "  - Static Assets: $STATIC_BUCKET"
echo ""

# Test 1: List buckets
echo "1️⃣ Testing bucket existence..."
if aws s3 ls 2>/dev/null | grep -q "$SCRAPED_BUCKET"; then
    echo -e "${GREEN}✅ Scraped data bucket exists${NC}"
else
    echo -e "${RED}❌ Scraped data bucket not found${NC}"
fi

if aws s3 ls 2>/dev/null | grep -q "$STATIC_BUCKET"; then
    echo -e "${GREEN}✅ Static assets bucket exists${NC}"
else
    echo -e "${RED}❌ Static assets bucket not found${NC}"
fi
echo ""

# Test 2: Upload test data to scraped bucket
echo "2️⃣ Testing upload to scraped data bucket..."
TEST_JSON='{"source":"test","timestamp":"'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'","data":"Hello from S3 test"}'
echo "$TEST_JSON" > /tmp/test-scraped.json

if aws s3 cp /tmp/test-scraped.json "s3://$SCRAPED_BUCKET/test/test-scraped.json" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Successfully uploaded test data${NC}"
    
    # Verify the upload
    if aws s3 ls "s3://$SCRAPED_BUCKET/test/test-scraped.json" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Verified test data exists${NC}"
    fi
else
    echo -e "${RED}❌ Failed to upload test data${NC}"
fi
echo ""

# Test 3: Test static website
echo "3️⃣ Testing static website hosting..."
TEST_HTML='<!DOCTYPE html>
<html>
<head><title>AI News Feed Test</title></head>
<body>
<h1>🚀 AI News Feed Static Site Test</h1>
<p>If you can see this, static hosting is working!</p>
<p>Deployed on: '$(date)'</p>
</body>
</html>'

echo "$TEST_HTML" > /tmp/test-index.html

if aws s3 cp /tmp/test-index.html "s3://$STATIC_BUCKET/test-index.html" --content-type "text/html" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Successfully uploaded test HTML${NC}"
    
    if [ ! -z "$WEBSITE_ENDPOINT" ]; then
        echo "📎 Test page URL: http://$WEBSITE_ENDPOINT/test-index.html"
        echo "   (Note: It may take a few seconds to be accessible)"
    fi
else
    echo -e "${RED}❌ Failed to upload test HTML${NC}"
fi
echo ""

# Test 4: Check lifecycle policies
echo "4️⃣ Checking lifecycle policies..."
if aws s3api get-bucket-lifecycle-configuration --bucket "$SCRAPED_BUCKET" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Lifecycle policies configured on scraped data bucket${NC}"
else
    echo -e "${RED}❌ No lifecycle policies found${NC}"
fi
echo ""

# Test 5: Check versioning
echo "5️⃣ Checking versioning configuration..."
VERSIONING=$(aws s3api get-bucket-versioning --bucket "$SCRAPED_BUCKET" --query 'Status' --output text 2>/dev/null || echo "")
if [ "$VERSIONING" == "Enabled" ]; then
    echo -e "${GREEN}✅ Versioning is enabled on scraped data bucket${NC}"
else
    echo -e "${RED}❌ Versioning is not enabled${NC}"
fi
echo ""

# Test 6: Check encryption
echo "6️⃣ Checking encryption configuration..."
if aws s3api get-bucket-encryption --bucket "$SCRAPED_BUCKET" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Encryption is configured${NC}"
else
    echo -e "${RED}❌ Encryption is not configured${NC}"
fi
echo ""

# Cleanup
echo "7️⃣ Cleaning up test files..."
rm -f /tmp/test-scraped.json /tmp/test-index.html
aws s3 rm "s3://$SCRAPED_BUCKET/test/test-scraped.json" 2>/dev/null || true
aws s3 rm "s3://$STATIC_BUCKET/test-index.html" 2>/dev/null || true
echo -e "${GREEN}✅ Cleanup complete${NC}"

echo ""
echo "======================================="
echo "🎉 S3 bucket testing complete!"
echo ""
echo "💡 Next steps:"
echo "  1. Review any failed tests above"
echo "  2. Check the static website URL if provided"
echo "  3. Commit your changes and create a PR"
echo ""
echo "📊 Cost reminder:"
echo "  - S3 Standard: \$0.023/GB/month"
echo "  - Lifecycle policies will reduce costs over time"
echo "  - Monitor usage in AWS Cost Explorer"