#/bin/bash


############################
# Author: Anurag
# Date: 19th-May
#
# Version: v1
#
# This script will report the AWS resource usage
############################


# AWS S3
# AWS EC2
# AWS Lamdba
# AWS IAM Users

set -x

# list s3 buckets
aws s3 ls >> resourceTracker

# list EC2 Instances
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker
# list lambda
aws lambda list-functions >> resourceTracker

# list IAM users
aws iam list-users >> resourceTracker                                  