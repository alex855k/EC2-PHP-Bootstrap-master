#!/bin/bash
set -e 
set -o pipefail
export PYTHONIOENCODING=utf8

VERSION=$1
ENVIRONMENT=$(echo "$2" | tr "[:upper:]" "[:lower:]")
REGION=$3
INSTANCE_TYPE=$4
MINIMUM_INSTANCES=$5
PROJECT_REPONAME=$6

case "${REGION}" in 
  "eu-central-1")
    MONO_REGIONS="fra"
  ;;
  "ca-central-1")
    MONO_REGIONS="yyz"
  ;;
esac
echo "Planning deployment of ${PROJECT_REPONAME} v${VERSION} to ${ENVIRONMENT} in ${REGION} (${MONO_REGIONS})"

VPC_NAME=$(echo "vpc-${ENVIRONMENT}-${REGION}" | tr "[:upper:]" "[:lower:]")
DEPLOYABLE="${PROJECT_REPONAME}-${CIRCLE_SHA1}.tar.gz"
BUCKET="mono-deployment-${ENVIRONMENT}"
FULL_BUCKET_URI="s3://${BUCKET}/ec2-bootstrap/${DEPLOYABLE}"
ALB_NAME="${ENVIRONMENT}-ec2-bootstrap-alb"

VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag-value,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --region "${REGION}" |  sed "s/\"//g")
# Get subnets to deploy to
PUBLIC_SUBNETS=$(aws ec2 describe-subnets --query "Subnets[?VpcId=='${VPC_ID}'].SubnetId" --filters  "Name=map-public-ip-on-launch, Values=true" --region "${REGION}" | tr -d "\\040\\011\\012\\015")
PRIVATE_SUBNETS=$(aws ec2 describe-subnets --query "Subnets[?VpcId=='${VPC_ID}'].SubnetId" --filters  "Name=map-public-ip-on-launch, Values=false" --region "${REGION}" | tr -d "\\040\\011\\012\\015")

ALB_ARN=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?LoadBalancerName=='${ALB_NAME}'].LoadBalancerArn" --region "${REGION}" | sed "s/\"//g" | tr -d "\\040\\011\\012\\015" | sed "s/[][]//g")
ALB_SG=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?LoadBalancerName=='${ALB_NAME}'].SecurityGroups" --region "${REGION}" | sed "s/\"//g" | tr -d "\\040\\011\\012\\015" | sed "s/[][]//g")

echo "Load Balancer Arn:" "$ALB_ARN"
echo "Load Balancer Security Group:" "$ALB_SG"
echo "Public Subnets:" "$PUBLIC_SUBNETS"
echo "Private Subnets:" "$PRIVATE_SUBNETS"

terraform plan \
  -var "version=${VERSION}" \
  -var "region=${REGION}" \
  -var "environment=${ENVIRONMENT}" \
  -var "vpc_id=${VPC_ID}" \
  -var "private_sns=${PRIVATE_SUBNETS}" \
  -var "alb_arn=${ALB_ARN}" \
  -var "alb_sg=${ALB_SG}" \
  -var "minimum_instance=${MINIMUM_INSTANCES}" \
  -var "instance_type=${INSTANCE_TYPE}" \
  -var "deployfileuri=${FULL_BUCKET_URI}" \
  -var "access_key=${AWS_ACCESS_KEY}" \
  -var "secret_key=${AWS_SECRET_KEY}" \
  -out "plan-${VERSION}.tfplan"