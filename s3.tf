# AWS S3 bucket resource definition
resource "aws_s3_bucket" "example" {
  bucket = "terraform-rs-school-state-devops-bucket-k8"  # Unique bucket name

  tags = {
    Name        = "RS School DevOps S3 Bucket"
    Environment = "Dev"
  }

  # Enable object lock to protect from accidental deletions (optional but recommended)
  object_lock_enabled = true
}

# S3 versioning configuration
resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"  # Enable versioning to keep previous versions of objects
  }
}

# AWS S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle" {
  bucket = aws_s3_bucket.example.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = 90  # Expire objects after 90 days
    }
  }

  # Optionally, add a cleanup rule for incomplete multipart uploads
  rule {
    id     = "cleanup-multipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7  # Clean up incomplete uploads after 7 days
    }
  }
}

# AWS S3 bucket policy
resource "aws_s3_bucket_policy" "example_policy" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "s3:GetObject",
      Effect    = "Deny",
      Resource  = "${aws_s3_bucket.example.arn}/*",  # Deny public access to the bucket
      Principal = "*"
    }]
  })

  depends_on = [
    aws_s3_bucket.example  # Ensure bucket is created before applying the policy
  ]
}
