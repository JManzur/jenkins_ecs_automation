##AWS Region
#Use: var.aws_region["source"]
variable "aws_region" {
  type = map(string)
  default = {
    "virginia" = "us-east-1",
    "oregon"   = "us-west-2"
  }
}

# AWS Region: North of Virginia
variable "aws_profile" {
  type    = string
  default = "CTesting"
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

### Task Definition Variables:
variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8082
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "health_check_path" {
  default = "/status"
}

### Tags Variables ###
#Use: tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-place-holder" }, )
variable "ProjectTags" {
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

variable "ecsNameTag" {
  type    = string
  default = "Ecs"
}