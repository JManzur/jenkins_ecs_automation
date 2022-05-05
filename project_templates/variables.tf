variable "aws_region" {
  description = "The AWS Region to deploy the resources"
  type        = string
}

variable "aws_profile" {
  description = "The aws-cli account credential profiles"
  type        = string
}

/* Tags Variables */
#Use: tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-place-holder" }, )
variable "ProjectTags" {
  description = "Key-value string map to tag the resources"
  type        = map(string)
}

variable "ECSTagPrefix" {
  description = "Prefix to be used in ECS resource name tagging"
  type        = string
}

variable "VPCTagPrefix" {
  description = "Prefix to be used in VPC resource name tagging"
  type        = string
}

variable "VPC_CIDR" {
  description = "Key-value string map of CIDR Block"
  type        = map(string)
}