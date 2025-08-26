terraform {
  backend "s3" {
    bucket = "testing-single-click-deployment-terraform-state"
    key    = "terraform-api.tfstate"
    region = "eu-west-1"
  }
}
