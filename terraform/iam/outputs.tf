# outputs.tf for IAM module

output "iam_role_arn" {
  description = "The ARN of the created IAM role."
  value       = aws_iam_role.github_actions_role.arn
}