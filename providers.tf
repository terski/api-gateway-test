terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Use a version that works for you
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
  # AWS CLI credentials will be used automatically
}
