module "s3_tfstate" {
  source      = "../../terraform/s3"
  bucket_name = var.s3_bucket_name
}

module "iam_github_role" {
  source         = "../../terraform/iam"
  role_name      = var.role_name
  github_org     = var.github_organization
  github_repo    = var.github_repository
  aws_account_id = var.aws_account_id
  policy_arns    = var.policy_arns
  kms_key_arn    = var.kms_key_arn # This was missing
}

module "vpc" {
  source = "../../terraform/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
  availability_zones   = var.availability_zones
  bastion_ami          = var.bastion_ami
  instance_type        = var.instance_type
  project_name         = var.project_name
}

module "ec2_k3s" {
  source                  = "../../terraform/ec2"
  ec2_ami_id              = var.ec2_ami_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_security_group_id = module.vpc.private_security_group_id
  bastion_key_name        = module.vpc.bastion_key_name
  project_name            = var.project_name
  bastion_key_path = "${path.module}/task2-bastion-key.pem"
}