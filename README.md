# rs-school-devops-course-tasks


# Terraform Plan Summary for Kubernetes Cluster Setup

## Overview

This Terraform plan is designed to set up a Kubernetes cluster using kOps on AWS. It provisions various AWS resources such as EC2 instances, VPC, subnets, security groups, and sets up monitoring with Grafana and Prometheus using Helm charts. The key components and actions in this plan are summarized below.

## AWS Resources

### Elastic IP (NAT)
- An Elastic IP for the NAT Gateway will be created.

### IAM Role for kOps
- A new IAM role for kOps (`kops-role`) will be created, attached with the `AmazonEC2FullAccess` policy.

### Bastion Host
- A bastion host using a `t2.micro` EC2 instance will be created to secure access to private instances.

### Multiple EC2 Instances
- Three `t2.micro` EC2 instances will be created, possibly used for Kubernetes worker nodes or masters.

### Private VM
- A separate private VM will be created for additional configuration or tasks.

### VPC (Virtual Private Cloud)
- A new VPC with a CIDR block of `10.0.0.0/16` will be created for the Kubernetes cluster.

### Subnets
- Two public and two private subnets will be created across multiple availability zones (`eu-west-1a` and `eu-west-1b`).

### Internet Gateway & NAT Gateway
- An Internet Gateway and a NAT Gateway will be provisioned to manage traffic between public and private subnets.

### Security Groups
- Security groups for the bastion host and private VMs will be created to allow controlled access to resources.
    - SSH access will be enabled for the bastion host.
    - HTTP access will be enabled for certain resources.

### S3 Bucket for kOps State Store
- An S3 bucket named `kops-state-store-rs-school` will be created to store the state of the kOps Kubernetes cluster.

### Route53 DNS Zone
- A Route53 DNS zone (`k8s.yourdomain.com`) will be created to manage the DNS for the Kubernetes cluster.

### Route Tables & Associations
- Public and private route tables and their associations will be created to manage network traffic between subnets and the internet.

## Helm Releases

### Grafana and Prometheus
- Grafana and Prometheus will be deployed using Helm charts in the Kubernetes cluster. These tools will be used for monitoring and visualizing the cluster's performance.
    - Both services will be exposed via `LoadBalancer`.

## Null Resource (Local Exec)

A `null_resource` is defined to execute the `kops create cluster` and `kops validate cluster` commands via a local-exec provisioner, which will create and validate the Kubernetes cluster.

## Outputs

- **kops_state_store**: Outputs the S3 bucket for kOps state storage (`kops-state-store-rs-school`).
- **kops_dns_zone**: Outputs the DNS zone for the Kubernetes cluster (`k8s.yourdomain.com`).

## Key Points
- **35 resources will be created**: The plan provisions all necessary AWS infrastructure for the Kubernetes cluster setup and monitoring.
- **No resources will be destroyed**: This plan focuses entirely on creating new resources.
- **Monitoring**: Grafana and Prometheus will be set up as monitoring tools in the cluster.



# Steps for K8s Cluster Deployment using kOps and Terraform

## 1. Set up Terraform Backend and Provider
Ensure the backend is configured for state management in AWS S3 and the provider is set for AWS.

```hcl
provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket     = "terraform-rs-school-state-devops-bucket-k8"
    key        = "dev/terraform.tfstate"
    region     = "eu-west-1"
    encrypt    = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

## 2. Create AWS VPC, Subnets, and Networking Resources
Define resources such as VPC, public and private subnets, internet gateways, NAT gateways, and route tables.

```hcl
resource "aws_vpc" "k8s_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s_vpc.id
}

# Additional networking resources like NAT, route tables, private subnets should be added similarly
```

## 3. Configure S3 State Store for kOps
kOps uses S3 as a state store. Create an S3 bucket and enable versioning.

```hcl
resource "aws_s3_bucket" "kops_state_store" {
  bucket = "kops-state-store-rs-school"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "kops_state_store_versioning" {
  bucket = aws_s3_bucket.kops_state_store.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

## 4. Create a DNS Zone in Route 53 for the Kubernetes Cluster
kOps requires a DNS zone for managing the cluster.

```hcl
resource "aws_route53_zone" "kops_dns_zone" {
  name = "k8s.yourdomain.com"
}
```

## 5. Create an IAM Role for kOps
Define the IAM role that will be used by kOps.

```hcl
resource "aws_iam_role" "kops_role" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }],
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "kops_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.kops_role.name
}
```

## 6. Execute kOps to Create the Cluster
Use Terraform's `null_resource` and `local-exec` to run kOps commands for creating the cluster.

```hcl
resource "null_resource" "run_kops_create_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      export KOPS_STATE_STORE=$(terraform output -raw kops_state_store)
      export NAME=cluster.k8s.yourdomain.com
      kops create cluster --name=${NAME} --state=${KOPS_STATE_STORE}       --zones=us-east-1a       --master-size=t2.micro --node-size=t2.micro --node-count=3       --dns-zone=$(terraform output -raw kops_dns_zone) --yes
    EOT
  }
}
```

## 7. Validate the Cluster
After creating the cluster, validate it with kOps.

```hcl
resource "null_resource" "validate_kops_cluster" {
  provisioner "local-exec" {
    command = "kops validate cluster --name=cluster.k8s.yourdomain.com --state=$(terraform output -raw kops_state_store)"
  }
}
```

## 8. Install Monitoring with Helm (Prometheus and Grafana)
Use Terraform to install Helm charts for Prometheus and Grafana for monitoring the K8s cluster.

```hcl
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}
```

## 9. Verify and Deploy a Sample Workload
Verify the Kubernetes cluster by running `kubectl get nodes` and deploying a sample workload.

```sh
kubectl get nodes
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
```

## 10. Clean Up
Once the tasks are complete, you can destroy the resources to avoid additional costs.

```sh
terraform destroy
```
