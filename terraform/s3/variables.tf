# variables.tf for S3 module

variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  type        = string
}