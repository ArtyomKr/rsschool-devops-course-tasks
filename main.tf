variable "region" { default = "eu-central-1" }

terraform {
  backend "s3" {
    bucket       = "artyomkr-terraform-state"
    key          = "rsschool/state"
    region       = "eu-central-1"
    encrypt      = "true"
    use_lockfile = "true"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}