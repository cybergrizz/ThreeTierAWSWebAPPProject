#List of available availability zones in given region
output "list_of_az" {
  value = data.aws_availability_zones.available-azs[*].names
}

#List of public subnet IDs
output "public_subnet_id" {
  value = data.aws_subnets.public[*].ids
}

#List of private subnet IDs
output "private_subnet_id" {
  value = data.aws_subnets.private[*].ids
}

#DB instance address
output "db-address" {
    value = aws_db_instance.db-instance.address
}