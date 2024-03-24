terraform {
  backend "s3" {
        bucket = "xitry-terraform-state"
        key    = "aws-proxy-server/terraform.tfstate"
        region = "us-east-1"
  }
}