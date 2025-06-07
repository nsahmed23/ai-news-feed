#!/bin/bash

# build-and-push-ecr.sh
# Script to build Docker images and push them to AWS ECR
#
# Usage: ./build-and-push-ecr.sh <ECR_REPO_URL> <DOCKERFILE_DIR>
#
# Example:
#   ./build-and-push-ecr.sh 123456789012.dkr.ecr.us-east-1.amazonaws.com/ai-news-feed-dev ./docker/app
#
# Requirements:
#   - AWS CLI installed and configured with appropriate credentials
#   - Docker installed and running
#   - Appropriate permissions to push to the ECR repository

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

print_info() {
    echo -e "${YELLOW}INFO: $1${NC}"
}

# Validate parameters
if [ $# -ne 2 ]; then
    print_error "Invalid number of arguments"
    echo "Usage: $0 <ECR_REPO_URL> <DOCKERFILE_DIR>"
    echo "Example: $0 123456789012.dkr.ecr.us-east-1.amazonaws.com/ai-news-feed-dev ./docker/app"
    exit 1
fi

ECR_REPO_URL=$1
DOCKERFILE_DIR=$2

# Validate ECR repository URL format
if ! [[ "$ECR_REPO_URL" =~ ^[0-9]+\.dkr\.ecr\.[a-z0-9-]+\.amazonaws\.com/[a-z0-9-/]+$ ]]; then
    print_error "Invalid ECR repository URL format"
    echo "Expected format: <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>"
    exit 1
fi

# Check if Dockerfile directory exists
if [ ! -d "$DOCKERFILE_DIR" ]; then
    print_error "Dockerfile directory does not exist: $DOCKERFILE_DIR"
    exit 1
fi

# Check if Dockerfile exists in the directory
if [ ! -f "$DOCKERFILE_DIR/Dockerfile" ]; then
    print_error "Dockerfile not found in: $DOCKERFILE_DIR"
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it first."
    echo "Visit: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install it first."
    exit 1
fi

# Extract region from ECR URL
AWS_REGION=$(echo "$ECR_REPO_URL" | cut -d'.' -f4)
if [ -z "$AWS_REGION" ]; then
    # If region extraction fails, use default or environment variable
    AWS_REGION=${AWS_REGION:-us-east-1}
fi

print_info "Using AWS region: $AWS_REGION"

# Get ECR login token
print_info "Logging in to ECR..."
if ! aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $ECR_REPO_URL; then
    print_error "Failed to login to ECR"
    exit 1
fi
print_success "Successfully logged in to ECR"

# Generate timestamp for tagging
TIMESTAMP=$(date +%Y%m%d%H%M%S)
print_info "Building Docker image with timestamp: $TIMESTAMP"

# Build Docker image with both latest and timestamp tags
print_info "Building Docker image from $DOCKERFILE_DIR..."
if ! docker build -t $ECR_REPO_URL:latest -t $ECR_REPO_URL:$TIMESTAMP $DOCKERFILE_DIR; then
    print_error "Failed to build Docker image"
    exit 1
fi
print_success "Docker image built successfully"

# Push both tags to ECR
print_info "Pushing image with tag 'latest' to ECR..."
if ! docker push $ECR_REPO_URL:latest; then
    print_error "Failed to push image with tag 'latest'"
    exit 1
fi
print_success "Successfully pushed image with tag 'latest'"

print_info "Pushing image with tag '$TIMESTAMP' to ECR..."
if ! docker push $ECR_REPO_URL:$TIMESTAMP; then
    print_error "Failed to push image with tag '$TIMESTAMP'"
    exit 1
fi
print_success "Successfully pushed image with tag '$TIMESTAMP'"

print_success "All operations completed successfully!"
echo "Images pushed:"
echo "  - $ECR_REPO_URL:latest"
echo "  - $ECR_REPO_URL:$TIMESTAMP"