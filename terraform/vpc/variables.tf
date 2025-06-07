variable "aws_region" {
  description = "Stockholm"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "RSchool DevOps"
  type        = string
  default     = "my-cloud-app"
}

variable "environment" {
  description = "Deployment environment intended for K8s"
  type        = string
  default     = "development"
}

variable "vpc_availability_zones" {
  description = "Availability zones for the VPC module in eu-north-1."
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instances."
  type        = string
  default     = "t3.micro"
}