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
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host."
  type        = string
}

variable "project_name" {
  description = "The name of the project for resource naming."
  type        = string
  default     = "task2"
}
#
# variable "key_name" {
#   description = "Name of the EC2 Key Pair for SSH access."
#   type        = string
# }