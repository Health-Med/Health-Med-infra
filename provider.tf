terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "healthmedbucket"
    key    = "healthmeddatabase/infra.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.regionDefault
  default_tags {
    tags = var.tags
  }  
}
