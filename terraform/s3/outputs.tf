# outputs.tf for S3 module

output "s3_bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.tfstate.id
}