data "aws_availability_zones" "aws" {
  state = "available"
}

#-------------------------------------
# VPC Definition A
#------------------------------------
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_cidr_a
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-vpc-a" }, )
}

#-------------------------------------
# SUBNET Definition A
#------------------------------------
# Public Subnet A
resource "aws_subnet" "public_a" {
  for_each          = { for i, v in var.PublicSubnet-List : i => v } 
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = cidrsubnet(var.vpc_cidr_a, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.aws.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-${each.value.name}" }, )
}

# private Subnet A
resource "aws_subnet" "private_a" {
  for_each          = { for i, v in var.PrivateSubnet-List : i => v }
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = cidrsubnet(var.vpc_cidr_a, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.aws.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-${each.value.name}" }, )
}


# Internet Gateway vpc A
resource "aws_internet_gateway" "ig_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-ig-a" }, )
}

# EIP for NAT Gateway A
resource "aws_eip" "nat_gateway_a" {
  vpc = true
}

# NAT Gateway A
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway_a.id
  subnet_id     = aws_subnet.public_a[0].id

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-ngw-b" }, )
}

#-------------------------------------
# Route table Definition A
#------------------------------------
# Public Route Table 
resource "aws_route_table" "public_route_table_a" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_a.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-rtpub" }, )
}

# Private Route Table 
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
       nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-rtpriv" }, )
}


# Public Subnets Association A
resource "aws_route_table_association" "public_a" {
  count          = length(var.PublicSubnet-List)
  subnet_id      = aws_subnet.public_a[count.index].id
  route_table_id = aws_route_table.public_route_table_a.id
}

# Private Subnets Association A
resource "aws_route_table_association" "private_a" {
  count          = length(var.PrivateSubnet-List)
  subnet_id      = aws_subnet.private_a[count.index].id
  route_table_id = aws_route_table.private_route_table_a.id
}


#-------------------------------------
# VPC Definition B
#------------------------------------
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_cidr_b
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-vpc-b" }, )
}

#------------------------------------
# SUBNET Definition B
#------------------------------------
# Public Subnet B
resource "aws_subnet" "public_b" {
  for_each          = { for i, v in var.PublicSubnet-List : i => v } 
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = cidrsubnet(var.vpc_cidr_b, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.aws.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-${each.value.name}" }, )
}

# private Subnet B
resource "aws_subnet" "private_b" {
  for_each          = { for i, v in var.PrivateSubnet-List : i => v }
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = cidrsubnet(var.vpc_cidr_b, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.aws.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-${each.value.name}" }, )
}

#------------------------
# Internet Gateway vpc B
#------------------------
resource "aws_internet_gateway" "ig_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-ig-b" }, )
}

# EIP for NAT Gateway B
resource "aws_eip" "nat_gateway_b" {
  vpc = true
}

# NAT Gateway B
resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_gateway_b.id
  subnet_id     = aws_subnet.public_a[0].id

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-ngw-b" }, )
}

#-------------------------------------
# Route table Definition B
#------------------------------------
# Public Route Table 
resource "aws_route_table" "public_route_table_b" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_b.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-rtpub" }, )
}

# Private Route Table 
resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.resource-name-tag}-rtpriv" }, )
}

# Public Subnets Association 
resource "aws_route_table_association" "public_b" {
  count          = length(var.PublicSubnet-List)
  subnet_id      = aws_subnet.public_b[count.index].id
  route_table_id = aws_route_table.public_route_table_b.id
}

# Private Subnets Association
resource "aws_route_table_association" "private_b" {
  count          = length(var.PrivateSubnet-List)
  subnet_id      = aws_subnet.private_b[count.index].id
  route_table_id = aws_route_table.private_route_table_b.id
}




