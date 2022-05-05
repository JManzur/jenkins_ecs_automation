#Get available AZ in the region.
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC A Definition
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.VPC_CIDR["VPC-A"]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A" }, )
}

# VPC B Definition
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.VPC_CIDR["VPC-B"]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-B" }, )
}

# VPC-A Flow Logs to CloudWatch
resource "aws_flow_log" "VPCALogs" {
  iam_role_arn    = aws_iam_role.vpc_fl_policy_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc_a.id
}

# VPC-B Flow Logs to CloudWatch
resource "aws_flow_log" "VPCBLogs" {
  iam_role_arn    = aws_iam_role.vpc_fl_policy_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc_b.id
}

# VPC-A Public Subnets
resource "aws_subnet" "PublicA" {
  for_each                = { for i, v in var.PublicSubnet-List : i => v }
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = cidrsubnet(var.VPC_CIDR["VPC-A"], each.value.newbits, each.value.netnum)
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-${each.value.name}" }, )
}

# VPC-B Public Subnets
resource "aws_subnet" "PublicB" {
  for_each                = { for i, v in var.PublicSubnet-List : i => v }
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = cidrsubnet(var.VPC_CIDR["VPC-B"], each.value.newbits, each.value.netnum)
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-B-${each.value.name}" }, )
}

# VPC-A Private Subnets
resource "aws_subnet" "PrivateA" {
  for_each          = { for i, v in var.PrivateSubnet-List : i => v }
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = cidrsubnet(var.VPC_CIDR["VPC-A"], each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.available.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-${each.value.name}" }, )
}

# VPC-B Private Subnets
resource "aws_subnet" "PrivateB" {
  for_each          = { for i, v in var.PrivateSubnet-List : i => v }
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = cidrsubnet(var.VPC_CIDR["VPC-B"], each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.available.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-B-${each.value.name}" }, )
}

# VPC-A Internet Gateway
resource "aws_internet_gateway" "internet_gateway_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-internet_gateway" }, )
}

# VPC-B Internet Gateway
resource "aws_internet_gateway" "internet_gateway_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-internet_gateway" }, )
}

# VPC-A Default Route Table
resource "aws_default_route_table" "PublicRouteTableA" {
  default_route_table_id = aws_vpc.vpc_a.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_a.id
  }
  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-B-default-rt" }, )
}

# VPC-B Default Route Table
resource "aws_default_route_table" "PublicRouteTableB" {
  default_route_table_id = aws_vpc.vpc_b.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_b.id
  }
  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-B-default-rt" }, )
}

# EIP for each NAT Gateway
resource "aws_eip" "nat_gateway" {
  count = 2
  vpc   = true
}

# VPC-A NAT Gateway
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id     = aws_subnet.PublicA[0].id

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-NG-A" }, )
}

# VPC-B NAT Gateway
resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_gateway[1].id
  subnet_id     = aws_subnet.PublicB[0].id

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-NG-B" }, )
}

# VPC-A Private Route Table
resource "aws_route_table" "private_route_table_a" {
  count  = length(var.PrivateSubnet-List)
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-RT-${count.index}" }, )
}

# VPC-B Private Route Table
resource "aws_route_table" "private_route_table_b" {
  count  = length(var.PrivateSubnet-List)
  vpc_id = aws_vpc.vpc_b.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.VPCTagPrefix}-A-RT-${count.index}" }, )
}

# VPC-A Private Subnets Association
resource "aws_route_table_association" "PrivateA" {
  count          = length(var.PrivateSubnet-List)
  subnet_id      = aws_subnet.PrivateA[count.index].id
  route_table_id = aws_route_table.private_route_table_a[count.index].id
}

# VPC-B Private Subnets Association
resource "aws_route_table_association" "PrivateB" {
  count          = length(var.PrivateSubnet-List)
  subnet_id      = aws_subnet.PrivateB[count.index].id
  route_table_id = aws_route_table.private_route_table_b[count.index].id
}