# s3.tf

# AWS S3 bucket resource definition
resource "aws_s3_bucket" "example" {
  bucket = "terraform-rs-school-state-devops-bucket"  # Unique bucket name

  tags = {
    Name        = "RS School DevOps S3 Bucket"
    Environment = "Dev"
  }
}

# S3 versioning configuration (moved here to avoid the deprecation warning)
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
}

# AWS S3 bucket policy to allow public read access
resource "aws_s3_bucket_policy" "example_policy" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "s3:GetObject",
      Effect    = "Allow",
      Resource  = "${aws_s3_bucket.example.arn}/*",  # Allow public read access to all objects
      Principal = "*"
    }]
  })

  depends_on = [
    aws_s3_bucket.example  # Ensure bucket is created before applying the policy
  ]
}
