terraform {
  backend "s3" {
    bucket = "rsschool-devops-tfstate-prod" # Must match the name above
    key    = "prod/terraform.tfstate"
    region = "eu-west-1"
  }
}