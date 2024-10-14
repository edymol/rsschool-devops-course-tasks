resource "aws_vpc" "k8s_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.k8s_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.k8s_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.k8s_vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.az_1
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.k8s_vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.az_2
}
