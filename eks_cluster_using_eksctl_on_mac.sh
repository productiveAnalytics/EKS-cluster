#!/usr/bin/env bash

# REFER: https://github.com/weaveworks/eksctl/tree/main/examples
echo 'REFER: https://github.com/weaveworks/eksctl/tree/main/examples'

# Update homebrew to get EKSCtl
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl

# Confirm eksctl
eksctl version

# EKSctl needs access to AWS session
# login using "aws-saml-auth" to establish AWS session
aws sts get-caller-identity

# Create cluster with supported Kubernetes version
export EKS_SUPPORTED_K8S_VERSION=1.21
export EKS_ENV_NAME=sbx
export EKS_CLUSTER_NAME=laap-eks-ue1-test-cluster-${EKS_ENV_NAME}
export EKS_MIN_NODES=3
export EKS_MAX_NODES=5

# NOTE: USE availability zones which match with VPC/Subnets

# Simple EC2-based cluster that gets created in NEW VPC
eksctl create cluster \
--name ${EKS_CLUSTER_NAME} \
--tags author=ProductiveAnalytics,usage=test,node_style=ec2 \
--region us-east-1 \
--zones us-east-1a,us-east-1b,us-east-1c

# EC2-based cluster, with static ASG and in existing private subnets of VPC 
eksctl create cluster \
--name ${EKS_CLUSTER_NAME} \
--tags author=ProductiveAnalytics,usage=test,node_style=ec2 \
--version ${EKS_SUPPORTED_K8S_VERSION} \
--region us-east-1 \
--nodegroup-name laap-k8s-ec2-nodes \
--node-type t2.micro \
--node-ami-family Ubuntu2004 \
--nodes 3 \
--instance-prefix my_eks \
--vpc-private-subnets  <PUT_VPC_Private_Subnect_IDs> \
--zones us-east-1a,us-east-1b,us-east-1c \
--enable-ssm \
--asg-access \
--alb-ingress-access

# Fargate-based cluster, with Auto Scaler, and in existing private subnets of VPC
eksctl create cluster \
--name ${EKS_CLUSTER_NAME} \
--tags author=ProductiveAnalytics,usage=test,node_style=fargate \
--version ${EKS_SUPPORTED_K8S_VERSION} \
--region us-east-1 \
--nodegroup-name laap-k8s-fargate-nodes \
--node-type t2.micro \
--nodes-min ${EKS_MIN_NODES} \
--nodes-max ${EKS_MAX_NODES} \
--instance-prefix my_eks \
--vpc-private-subnets  <PUT_VPC_Private_Subnect_IDs> \
--zones us-east-1a,us-east-1b,us-east-1c \
--enable-ssm \
--asg-access \
--alb-ingress-access \
--fargate

# To check the stack
eksctl utils describe-stacks \
--region us-east-1 \
--cluster ${EKS_CLUSTER_NAME}

# To enable CloudWatch events for EKS cluster
eksctl utils update-cluster-logging \
--enable-types=all \
--region us-east-1 \
--cluster ${EKS_CLUSTER_NAME} \
--approve

# Typically EKSctl install KubeConfig under ~/.kube/config
# Run KubeCtl commands, like
kubectl get nodes
kubectl get ns
kubectl get deployments
kubectl get services
kubectl get pods --all-namespaces -o wide

## To confirm working of Kubernetes pods: either use "cUrl -X GET" or browser to visit the EXTERNAL-IP from the output of "kubectl get services" for TYPE=LoadBalancer

# TO CLEAN-UP
# eksctl delete cluster --name ${EKS_CLUSTER_NAME}
