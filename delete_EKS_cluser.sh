#! /usr/sh

# Use the profile which has IAM rights
export AWS_PROFILE=prod8ctive
echo "Using AWS profile: $AWS_PROFILE"

export AWS_REGION=us-east-1
echo "Using AWS region: $AWS_REGION"

# Check any existing EKS cluster
eksctl get cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION

# Delete secret
kubectl delete secret mysql-pass
# confirm deletion
kubectl get secrets

# Delete deployment, service and data-volume
kubectl delete deployment -l app=wordpress
kubectl delete service -l app=wordpress
kubectl delete pvc -l app=wordpress
# confirm deletion
kubectl get deployments
kubectl get pods
kubectl get pvc

# use profile "prod8ctive" and region "us-east-1" 
eksctl delete cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION \
  --name wp-cluster

# confirm deletion
eksctl get cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION