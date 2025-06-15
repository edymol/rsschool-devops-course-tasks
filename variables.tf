# CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Public Subnets CIDR Blocks
variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

# Private Subnets CIDR Blocks
variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  default     = "10.0.4.0/24"
}

variable "private_subnet_3_cidr" {
  description = "CIDR block for Private Subnet 3"
  default     = "10.0.5.0/24"
}

variable "private_subnet_4_cidr" {
  description = "CIDR block for Private Subnet 4"
  default     = "10.0.6.0/24"
}

# Availability Zones
variable "az_1" {
  description = "First Availability Zone (AZ) for subnets"
  default     = "eu-west-1a"  # Update based on your preferred region
}

variable "az_2" {
  description = "Second Availability Zone (AZ) for subnets"
  default     = "eu-west-1b"  # Update based on your preferred region
}

# Local IP Address for SSH Access (for the security group)
variable "local_ip" {
  description = "Your local IP address for SSH access"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS Key ID for S3 encryption"
  type        = string
}
