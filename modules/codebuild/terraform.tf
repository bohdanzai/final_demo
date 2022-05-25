provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
      version = "~> 4.14"
    }
  }
}