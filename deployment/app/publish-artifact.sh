#!/bin/bash
set -e

ENVIRONMENT=$(echo "$1" | tr "[:upper:]" "[:lower:]")
BUCKET="mono-deployment-${ENVIRONMENT}"
DEPLOYABLE="${CIRCLE_PROJECT_REPONAME}-${CIRCLE_SHA1}.tar.gz"
{
  aws s3api create-bucket --bucket "${BUCKET}"
} || {
  echo "Bucket is here"
}
aws s3 cp "$HOME/EC2-PHP-Bootstrap/artifact/${DEPLOYABLE}" "s3://${BUCKET}/ec2-bootstrap/${DEPLOYABLE}"