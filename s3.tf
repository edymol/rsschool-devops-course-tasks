resource "aws_s3_bucket" "example" {
  bucket = "terraform-rs-school-state-devops-bucket-k8"

  tags = {
    Name        = "RS School DevOps S3 Bucket"
    Environment = "Dev"
  }

  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

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
