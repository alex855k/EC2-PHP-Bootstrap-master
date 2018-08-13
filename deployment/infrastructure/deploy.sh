#!/bin/bash
set -e 

# ENVIRONMENT=$(echo "$2" | tr "[:upper:]" "[:lower:]")
# REGION=$3
# INSTANCE_TYPE=$4
# MINIMUM_INSTANCES=$5
# PROJECT_REPONAME=$6
ENVIRONMENT="dev"
REGION="eu-central-1"

VPC_NAME=$(echo "vpc-${ENVIRONMENT}-${REGION}" | tr "[:upper:]" "[:lower:]")
ALB_NAME="ec2-bootstrap-alb"
# Assumes that the VPC selected has a Name Tag
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag-value,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --region "${REGION}" |  sed "s/\"//g")
# Get subnets to deploy to
PUBLIC_SUBNETS=$(aws ec2 describe-subnets --query "Subnets[?VpcId=='${VPC_ID}'].SubnetId" --filters  "Name=map-public-ip-on-launch, Values=true" --region "${REGION}" | tr -d "\\040\\011\\012\\015")

echo "Public Subnets:" "$PUBLIC_SUBNETS"

terraform init

terraform plan \
 -var "environment=${ENVIRONMENT}" \
 -var "vpc_id=${VPC_ID}" \
 -var "region=${REGION}" \
 -var "name=${ALB_NAME}" \
 -var "alb_subnets=${PUBLIC_SUBNETS}" \
 -out app_alb_deployment_plan

terraform apply "app_alb_deployment_plan"
