module "s3_tfstate" {
  source      = "../../terraform/s3"
  bucket_name = var.s3_bucket_name
}

module "iam_github_role" {
  source         = "../../terraform/iam"
  role_name      = var.role_name
  github_org     = var.github_organization
  github_repo    = var.github_repository
  aws_account_id = var.aws_account_id
  policy_arns    = var.policy_arns
}