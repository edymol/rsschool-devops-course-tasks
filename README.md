# rsschool-devops-course-tasks

## Setup identify provider and GithubActionsRole

1. Created a new identity provider for github.
2. Created a new role with required policy to access my github repo and attached the required permissions. The configuration can be found in iam_role.tf file.

### Setup github actions
1. Created a workflow for github that will be triggered any time we have a PR to main or push to the main branch.
2. Created repo secrets to store AWS KEY_ID and SECRET.

### Confirmed the workflow works.
The logfile of a workflow is also attached as part of the PR.

# Task 2 

### AWS Kubernetes VPC Setup with Terraform
This Terraform configuration sets up the foundational networking infrastructure required for deploying a Kubernetes (K8s) cluster on AWS. The configuration provisions a Virtual Private Cloud (VPC) along with public and private subnets, Internet Gateway, NAT Gateway, route tables, security groups, and an S3 bucket for storing the Terraform state.

#### Project Overview
- This project creates the following AWS resources:

## VPC: A Virtual Private Cloud (VPC) with a custom CIDR block.
- Subnets: Two public subnets and two private subnets, each distributed across different availability zones.
- Internet Gateway (IGW): Provides internet access to the public subnets.
- NAT Gateway: Allows instances in private subnets to connect to the internet while remaining inaccessible from the outside.
- Route Tables: Routes network traffic to the appropriate destinations for public and private subnets.
- Security Groups: Security rules to control inbound and outbound traffic for the public and private instances.
- S3 Bucket: A bucket to store the Terraform state file and enable versioning and lifecycle policies.
### AWS Resources Provisioned
1. VPC (Virtual Private Cloud)
   CIDR Block: 10.0.0.0/16
   Provides an isolated network for AWS resources.
   VPC ID: vpc-01d28899bf72190e6 (as per the Terraform state)
2. Subnets
   Public Subnets:
   public_subnet_1: Located in us-east-1a
   public_subnet_2: Located in us-east-1b
   These subnets are exposed to the internet, allowing resources such as a bastion host or load balancer to be publicly accessible.
   Private Subnets:
   private_subnet_1: Located in us-east-1a
   private_subnet_2: Located in us-east-1b
   These subnets are private and do not have direct access to the internet. Resources like database instances or backend servers reside here.
3. Internet Gateway (IGW)
   Enables resources in the public subnets to have direct access to the internet.
4. NAT Gateway
   Allows instances in private subnets to initiate outbound traffic to the internet, but prevents inbound traffic from the internet.
   Created in public_subnet_1.
5. Route Tables
   Public Route Table: Routes traffic from the public subnets to the Internet Gateway.
   Private Route Table: Routes traffic from the private subnets to the NAT Gateway for internet access.
6. Security Groups
   Public Security Group:
   Allows SSH (port 22) access from anywhere (0.0.0.0/0) for the bastion host.
   Private Security Group:
   Allows SSH access only from your local IP or the bastion host. The local IP is specified as a variable for secure SSH access to private instances.
7. S3 Bucket
   S3 Bucket (terraform-rs-school-state-devops-bucket) is used for storing the Terraform state.
   Versioning: Enabled to keep track of changes to the Terraform state.
   Lifecycle Rule: Objects (logs) in the bucket are automatically deleted after 90 days.
   Public Access: The S3 bucket has a policy that allows public read access to its contents (for specific objects if necessary).
   Usage
   Prerequisites
   Terraform installed on your local machine.
   AWS account and IAM user/role with the necessary permissions to create resources such as VPCs, EC2 instances, S3 buckets, etc.
   AWS CLI configured with appropriate credentials.
   Variables
   The following variables need to be provided to customize the setup:

### vpc_cidr: The CIDR block for the VPC (default: 10.0.0.0/16).
### public_subnet_1_cidr: CIDR block for the first public subnet.
### public_subnet_2_cidr: CIDR block for the second public subnet.
### private_subnet_1_cidr: CIDR block for the first private subnet.
### private_subnet_2_cidr: CIDR block for the second private subnet.
### local_ip: Your local IP address for secure SSH access to the private instances.
### You can define these in a terraform.tfvars file, for example:

- hcl
- Copy code
- local_ip = "192.0.24"
- Commands
### Initialize Terraform:

- bash
- Copy code
- terraform init
- - This command initializes the backend and downloads the necessary provider plugins.

### Plan the Infrastructure:

- bash
- Copy code
- terraform plan
- - This command shows you the actions Terraform will take to create/update the infrastructure.

### Apply the Infrastructure:

- bash
- Copy code
- terraform apply
- - This command creates/updates the infrastructure. You will be prompted to confirm.

### Destroy the Infrastructure:

- bash
- Copy code
- terraform destroy
- - This command tears down all the resources defined in the Terraform files.

### GitHub Actions (CI/CD)
The configuration includes a GitHub Actions workflow for running the Terraform plan and apply commands. The workflow:

- Checks the formatting of Terraform files.
- Plans the infrastructure changes.
- Applies the changes to your AWS environment when required.
#### Notes
- Ensure that the terraform.tfvars file or sensitive variables (such as your local IP) are not committed to version control by adding them to .gitignore.
- Always run terraform plan before terraform apply to review any infrastructure changes.

