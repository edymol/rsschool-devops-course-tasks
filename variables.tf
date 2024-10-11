variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  default = "10.0.4.0/24"
}

variable "az_1" {
  default = "us-east-1a"  # Updated to us-east-1
}

variable "az_2" {
  default = "us-east-1b"  # Updated to us-east-1
}

# variable "bastion_ami" {
#   description = "AMI ID for the Bastion Host"
#   type        = string
# }
variable "local_ip" {
  description = "Your local IP address for SSH access"
  type        = string
}
