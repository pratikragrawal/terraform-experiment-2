terraform {
  backend "s3" {
    bucket = "experiment2-terraform-state-581117995813"
    key    = "experiment2/terraform.tfstate"
    region = "ap-south-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  admin_cidr          = var.admin_cidr
}

module "compute" {
  source = "./modules/compute"

  web_count             = var.web_count
  instance_type         = var.instance_type
  public_subnet_id      = module.network.public_subnet_id
  private_subnet_id     = module.network.private_subnet_id
  web_security_group_id = module.network.web_security_group_id
  db_security_group_id  = module.network.db_security_group_id
  key_name              = var.key_name
}