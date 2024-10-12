# VPC Definition
resource "aws_vpc" "k8s_vpc" {
  cidr_block = var.vpc_cidr
}

# Public Subnet 1 (AZ 1)
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true
}

# Public Subnet 2 (AZ 2)
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true
}

# Private Subnet 1 (AZ 1)
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az_1
}

# Private Subnet 2 (AZ 2)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az_2
}

# Private Subnet 3 (AZ 1)
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = var.az_1
}

# Private Subnet 4 (AZ 2)
resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_subnet_4_cidr
  availability_zone = var.az_2
}
