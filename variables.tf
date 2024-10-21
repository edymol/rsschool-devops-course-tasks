variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  default     = "10.0.4.0/24"
}

variable "az_1" {
  description = "First Availability Zone (AZ) for subnets"
  default     = "eu-west-1a"
}

variable "az_2" {
  description = "Second Availability Zone (AZ) for subnets"
  default     = "eu-west-1b"
}

variable "local_ip" {
  description = "Your local IP address for SSH access"
  type        = list(string)
}

variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
  default     = "rs-school-eu"
}

variable "kops_s3_bucket" {
  description = "S3 bucket for storing kOps cluster state"
  default     = "terraform-rs-school-state-devops-bucket-k8-1"
}

variable "my_ip_cidr" {
  description = "Your IP range for SSH access"
  default     = "0.0.0.0/0"  # Replace with your actual IP or IP range
}

variable "kms_key_id" {
  description = "KMS Key ID for encryption"
  type        = string
}
