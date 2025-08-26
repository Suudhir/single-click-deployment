terraform {
  backend "s3" {
    bucket = "testing-single-click-deployment-terraform-state"
    key    = "terraform-rds.tfstate"
    region = "eu-west-1"
  }
}
