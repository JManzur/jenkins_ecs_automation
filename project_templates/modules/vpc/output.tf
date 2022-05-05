output "vpc_a_id" {
  description = "The VPC-A ID"
  value       = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  description = "The VPC-B ID"
  value       = aws_vpc.vpc_b.id
}

output "public_a_subnet" {
  value       = values(aws_subnet.PublicA)[*].id
  description = "The ID of each Public Subnet in VPC-A"
}

output "public_b_subnet" {
  value       = values(aws_subnet.PublicB)[*].id
  description = "The ID of each Public Subnet in VPC-B"
}

output "private_a_subnet" {
  value       = values(aws_subnet.PrivateA)[*].id
  description = "The ID of each Private Subnet in VPC-A"
}

output "private_b_subnet" {
  value       = values(aws_subnet.PrivateB)[*].id
  description = "The ID of each Private Subnet in VPC-B"
}