# AWS provider version definition
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create a VPC
module "vpc" {
  source       = "./modules/vpc"
  ProjectTags  = var.ProjectTags
  VPCTagPrefix = var.VPCTagPrefix
  AWSRegion    = var.aws_region
  VPC_CIDR     = var.VPC_CIDR
}