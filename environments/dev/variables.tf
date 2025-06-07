variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-1"
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