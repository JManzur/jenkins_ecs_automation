## Output VPC ##
output "vpc_id_a" {
  value       = aws_vpc.vpc_a.id
  description = "VPC A ID"
}

output "vpc_id_b" {
  value       = aws_vpc.vpc_b.id
  description = "VPC B ID"
}

## Output Subnet A ##

output "public_subnet_a" {
  value       = values(aws_subnet.public_a)[*].id
  description = "Public Subnets ID"
}

output "private_subnet_a" {
  value       = values(aws_subnet.private_a)[*].id
  description = "Private Subnets ID"
}

## Output Subnet B ##

output "public_subnet_b" {
  value       = values(aws_subnet.public_b)[*].id
  description = "Public Subnets ID"
}

output "private_subnet_b" {
  value       = values(aws_subnet.private_b)[*].id
  description = "Private Subnets ID"
}

