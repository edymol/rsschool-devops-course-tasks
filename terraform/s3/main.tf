# This resource defines the S3 bucket itself.
resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name

  # This is the correct way to protect the bucket from accidental deletion by Terraform.
  lifecycle {
    prevent_destroy = false
  }
}

# This resource enables versioning on the bucket.
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# This resource configures default server-side encryption.
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_sse" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This resource blocks all public access to the bucket.
resource "aws_s3_bucket_public_access_block" "tfstate_public_access" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}