variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host."
  type        = string
}