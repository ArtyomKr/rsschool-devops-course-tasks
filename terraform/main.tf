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
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  aws_region         = var.aws_region
  ec2_iam            = var.ec2_iam
  ec2_instance_type  = var.ec2_instance_type
  allowed_access_ips = var.allowed_access_ips
}

module "k3s" {
  source     = "./modules/k3s"
  depends_on = [module.networking]

  ec2_iam            = var.ec2_iam
  ec2_instance_type  = var.ec2_instance_type
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  bastion_sg_id      = module.networking.bastion_sg_id
}