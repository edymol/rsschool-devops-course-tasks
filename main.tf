provider "aws" {
  region = "eu-west-1"
}

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

output "kops_state_store" {
  value = "s3://${aws_s3_bucket.kops_state_store.bucket}"
}

output "kops_dns_zone" {
  value = aws_route53_zone.kops_dns_zone.name
}
