variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances in eu-north-1."
  type        = string
  default     = "ami-0152ea7e79f25bb5b" # <-- YOUR UBUNTU 24.04 AMI ID HERE
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for k3s nodes."
  type        = list(string)
}

variable "private_security_group_id" {
  description = "Security group ID for private k3s nodes."
  type        = string
}

variable "bastion_key_name" {
  description = "Key pair name for SSH access to k3s nodes."
  type        = string
}

variable "project_name" {
  description = "The name of the project for resource naming."
  type        = string
}

variable "bastion_key_path" {
  description = "The absolute path to the .pem file for the bastion key, used for remote-exec."
  type        = string
}
