# Shared Variables
ProjectTags = {
  Service     = "AppConfig POC",
  Environment = "POC",
  DeployedBy  = "example@mail.com"
}
aws_region  = "us-east-1"
aws_profile = "default"

# VPC Variables
VPCTagPrefix = "VPC"
VPC_CIDR = {
  VPC-A = "10.48.0.0/16",
  VPC-B = "10.49.0.0/16",
}

# ECS Variables
ECSTagPrefix = "ECS"