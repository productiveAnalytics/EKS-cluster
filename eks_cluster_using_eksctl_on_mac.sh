#!/usr/bin/env bash

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
export EKS_CLUSTER_NAME=laap-eks-ue1-test-cluster-sbx
export EKS_MIN_NODES=3
export EKS_MAX_NODES=5

# Simple cluster with static ASG and in new VPC and nodes as EC2
eksctl create cluster \
--name ${EKS_CLUSTER_NAME} \
--version ${EKS_SUPPORTED_K8S_VERSION} \
--region us-east-1 \
--nodegroup-name laap-k8s-nodes \
--node-type t2.micro \
--nodes 3

# Complex cluster with Auto Scaler, and in existing private subnets of VPC and Fargate based nodes
eksctl create cluster \
--name ${EKS_CLUSTER_NAME} \
--tags author=ProductiveAnalytics usage=test \
--version ${EKS_SUPPORTED_K8S_VERSION} \
--region us-east-1 \
--nodegroup-name laap-k8s-nodes \
--node-type t2.micro \
--nodes-min ${EKS_MIN_NODES} \
--nodes-max ${EKS_MAX_NODES} \
--node-ami-family Ubuntu2004 \
--instance-prefix my_eks \
--vpc-private-subnets  <PUT_VPC_Private_Subnect_IDs> \
--enable-ssm \
--asg-access \
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
kubectl get pod

# TO CLEAN-UP
# eksctl delete cluster --name ${EKS_CLUSTER_NAME}
