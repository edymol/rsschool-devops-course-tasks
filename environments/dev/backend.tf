terraform {
  backend "s3" {
    bucket  = "rsschool-devops-tfstate-dev"
    key     = "dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}