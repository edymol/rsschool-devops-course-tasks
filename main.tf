# Configure the backend to store the Terraform state in an S3 bucket

terraform {
  backend "s3" {
    bucket     = "terraform-rs-school-state-devops-bucket-k8"
    key        = "dev/terraform.tfstate"
    region     = "eu-west-1"
    encrypt    = true
  }

  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}


# AWS provider configuration
# provider "aws" {
#   region = "us-east-1"
# }
#
# # AWS S3 bucket resource definition
# resource "aws_s3_bucket" "example" {
#   bucket = "terraform-rs-school-state-devops-bucket" # Updated to a unique bucket name
#
#   versioning {
#     enabled = true
#   }
#
#   lifecycle_rule {
#     enabled = true
#     noncurrent_version_expiration {
#       days = 30
#     }
#   }
# }
#
# # AWS S3 bucket policy definition to allow public read access
# resource "aws_s3_bucket_policy" "example_policy" {
#   bucket = aws_s3_bucket.example.id
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action    = "s3:GetObject",
#       Effect    = "Allow",
#       Resource  = "${aws_s3_bucket.example.arn}/*", # Correct ARN reference
#       Principal = "*"
#     }]
#   })
#
#   # Ensure the bucket is created before applying the policy
#   depends_on = [
#     aws_s3_bucket.example
#   ]
# }
