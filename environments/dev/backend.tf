# environments/dev/backend.tf

terraform {
  backend "s3" {
    bucket = "rsschool-devops-tfstate-dev"
    key    = "dev/terraform.tfstate"
    # The region must be hardcoded in the backend configuration.
    region = "eu-west-1"
    encrypt = true
  }
}