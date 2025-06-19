# This creates the OIDC provider that allows AWS to trust GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# This data source creates the trust policy document
data "aws_iam_policy_document" "github_actions_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main",
        "repo:${var.github_org}/${var.github_repo}:pull_request"
      ]
    }
  }
}

# This creates the IAM role
resource "aws_iam_role" "github_actions_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json
}

# This attaches the AWS managed permissions to the role
resource "aws_iam_role_policy_attachment" "attach_policies" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.value
}

# Creates a new policy for KMS permissions
resource "aws_iam_policy" "kms_for_backend" {
  name        = "KMS-Permissions-For-S3-Backend"
  description = "Allows use of the KMS key for the Terraform backend"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = var.kms_key_arn
      },
    ]
  })
}

# Attaches the new KMS policy to the GithubActionsRole
resource "aws_iam_role_policy_attachment" "attach_kms_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.kms_for_backend.arn
}