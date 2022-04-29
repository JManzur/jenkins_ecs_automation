##AWS Region
#Use: var.aws_region["source"]
variable "aws_region" {
  type = map(string)
  default = {
    "virginia" = "us-east-1",
    "oregon"   = "us-west-2"
  }
}

# VPC  cidr block
variable "vpc_cidr_a" {
  type    = string
  default = ""
}

variable "vpc_cidr_b" {
  type    = string
  default = ""
}

#Use for subnet: tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-${each.value.name}" }, )
variable "PublicSubnet-List" {
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
  default = [
    {
      name    = "Public-0"
      az      = 0
      newbits = 8
      netnum  = 10
    },
    {
      name    = "Public-1"
      az      = 1
      newbits = 8
      netnum  = 11
    },    
  ]
}

variable "PrivateSubnet-List" {
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
  default = [
    {
      name    = "Private-0"
      az      = 0
      newbits = 8
      netnum  = 20
    },
    {
      name    = "Private-1"
      az      = 0
      newbits = 8
      netnum  = 21
    },
    {
      name    = "Private-2"
      az      = 1
      newbits = 8
      netnum  = 22
    },
    {
      name    = "Private-3"
      az      = 1
      newbits = 8
      netnum  = 23
    },
  ]
}

### Tags Variables ###
#Use: tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-place-holder" }, )
variable "project-tags" {
  type = map(string)
  default = {
    service     = "Ec2",
    environment = "POC"
  }
}

variable "resource-name-tag" {
  type    = string
  default = "vpc"
}
