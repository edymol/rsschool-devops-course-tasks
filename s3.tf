# Example S3 bucket for general state management
resource "aws_s3_bucket" "example" {
  bucket = "terraform-rs-school-state-devops-bucket-k8-1"

  tags = {
    Name        = "RS School DevOps S3 Bucket"
    Environment = "Dev"
  }

  # If you do not require Object Lock, you can keep it commented out
  # object_lock_enabled = true

  lifecycle {
    prevent_destroy = false
  }
}

# Enable versioning for the general S3 bucket
resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle policy for the general S3 bucket (optional but recommended)
resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle" {
  bucket = aws_s3_bucket.example.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = 90
    }
  }

  rule {
    id     = "cleanup-multipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# S3 bucket policy for general usage (restricting public access, example)
resource "aws_s3_bucket_policy" "example_policy" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "s3:GetObject",
      Effect    = "Deny",
      Resource  = "${aws_s3_bucket.example.arn}/*",
      Principal = "*"
    }]
  })

  depends_on = [
    aws_s3_bucket.example
  ]
}

# Enable versioning for the kOps state store (reusing the general S3 bucket)
resource "aws_s3_bucket_versioning" "kops_state_store_versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

# (Optional) Lifecycle policy for the kOps state store (adjust as needed)
resource "aws_s3_bucket_lifecycle_configuration" "kops_state_store_lifecycle" {
  bucket = aws_s3_bucket.example.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = 90
    }
  }

  rule {
    id     = "cleanup-multipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# (Optional) Bucket policy for kOps state store (restrict access as needed)
resource "aws_s3_bucket_policy" "kops_state_store_policy" {
  bucket = aws_s3_bucket.example.id  # Reuse the 'example' S3 bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
      Resource = [
        "${aws_s3_bucket.example.arn}",
        "${aws_s3_bucket.example.arn}/*"
      ],
      Principal = {
        AWS = [
          "arn:aws:iam::981603173951:user/EdyMolina",  # Allow your user
          "arn:aws:iam::981603173951:role/kops-role"   # Allow the kOps role
        ]
      }
    }]
  })

  depends_on = [
    aws_s3_bucket.example  # Corrected dependency
  ]
}
