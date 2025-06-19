variable "role_name" {
  description = "The name of the IAM role for GitHub Actions."
  type        = string
  default     = "GithubActionsRole"
}

variable "github_org" {
  description = "Your GitHub organization or username."
  type        = string
}

variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
}

variable "aws_account_id" {
  description = "Your AWS Account ID."
  type        = string
}

variable "policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key."
  type        = string
}