# terraform/s3/main.tf

resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name
}

# This new resource replaces the deprecated inline block
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_sse" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate_lifecycle" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    id     = "prevent_destroy"
    status = "Enabled"

    # This configuration is a safeguard, but the primary prevent_destroy
    # mechanism for Terraform is the lifecycle block below.
    # We add this rule for completeness.
  }
}

# The primary Terraform mechanism to prevent accidental deletion
resource "aws_s3_bucket" "tfstate_prevent_destroy" {
  bucket = aws_s3_bucket.tfstate.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_public_access" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}