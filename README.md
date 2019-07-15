# EKS-cluster
Setting AWS EKS cluster using eksctl, kubectl and aws-iam-authenticatorRefer: https://eksctl.io

#=== Setup of EKS ctl, Kube ctl and aws-iam-authenticator ===#
# Go to the folder
cd ~/opt/EKSctl
# Add to PATH  
export PATH="~/opt/EKSctl:$PATH"

# Download the tarball for EKSctl and unzip to /tmp
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# Move the eksctl executable to the location
mv /tmp/eksctl ~/opt/EKSctl/
# Confirm the eksctl version
eksctl version

# Download kubectl (from Amazon site: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/kubectl
# Access
chmod +x kubectl

# Download aws-iam-authenticator : https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator
# Access
chmod +x aws-iam-authenticator

References: 
- https://app.pluralsight.com/player?course=using-docker-aws&author=david-clinton
- https://bootstrap-it.com/docker4aws/#kube-cluster  