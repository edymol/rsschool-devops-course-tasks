variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "s3_bucket_name" {
  description = "The unique name for the S3 state bucket."
  type        = string
}

variable "github_organization" {
  description = "Your GitHub username or organization name."
  type        = string
}

variable "github_repository" {
  description = "The name of your GitHub repository."
  type        = string
}

variable "aws_account_id" {
  description = "Your AWS Account ID for the IAM role trust policy."
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role for GitHub Actions."
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the GitHub Actions role."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for S3 backend encryption."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host."
  type        = string
  default     = "ami-0f33411e8740e3c70"
}

variable "instance_type" {
  description = "Instance type for the bastion host."
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "The name of the project for resource naming."
  type        = string
  default     = "task2"
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances in eu-west-1."
  type        = string
  default     = "ami-0c1ac8a41498c1a9c" # Ubuntu 24.04, adjust if needed
}