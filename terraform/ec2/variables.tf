variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances in eu-west-1."
  type        = string
  default     = "ami-0a8e566d0e6df5b5b"
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

variable "bastion_private_key" {
  description = "The private key for SSH access to the bastion and k3s nodes."
  type        = string
  sensitive   = true
}

variable "bastion_public_ip" {
  description = "Public IP of the bastion host for SSH proxy."
  type        = string
}