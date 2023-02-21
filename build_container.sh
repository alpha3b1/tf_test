#!/bin/bash

REP_NAME="pyxis/web-app"
BASE_PATH=/home/isaac/workspace/pyxis-test
AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`

QUERY_REP=`aws ecr describe-repositories --repository-names $REP_NAME 2>/dev/null`

if [ $? -ne 0 ]; then
	aws ecr create-repository --repository-name $REP_NAME
fi

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
docker build -t ${REP_NAME} $BASE_PATH
docker tag ${REP_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${REP_NAME}:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${REP_NAME}:latest
