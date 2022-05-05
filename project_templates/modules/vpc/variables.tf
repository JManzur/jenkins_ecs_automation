# Values come from provieder.tf
variable "ProjectTags" {}
variable "VPCTagPrefix" {}
variable "AWSRegion" {}
variable "VPC_CIDR" {}

variable "PublicSubnet-List" {
  description = "Key-value map to dynamically build de CIDR Block Ref.: https://www.terraform.io/language/functions/cidrsubnet"
  type = list(object({
    name    = string #To be used in Name tag
    az      = number #Availability Zone to place the subnet
    newbits = number #New bits to add to the netmask.
    netnum  = number #Third octet value of the IP Segment
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
  description = "Key-value map to dynamically build de CIDR Block Ref.: https://www.terraform.io/language/functions/cidrsubnet"
  type = list(object({
    name    = string #To be used in Name tag
    az      = number #Availability Zone to place the subnet
    newbits = number #New bits to add to the netmask.
    netnum  = number #Third octet value of the IP Segment
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
      az      = 1
      newbits = 8
      netnum  = 21
    },
    {
      name    = "Private-3"
      az      = 2
      newbits = 8
      netnum  = 22
    },
    {
      name    = "Private-4"
      az      = 3
      newbits = 8
      netnum  = 23
    }
  ]
}