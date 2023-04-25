#List of available availability zones in given region
output "list_of_az" {
  value = data.aws_availability_zones.available-azs[*].names
}

#List of public subnet IDs
output "public_subnet_id" {
  value = data.aws_subnets.public-subnets-tf[*].ids
}

#List of private subnet IDs
output "private_subnet_id" {
  value = data.aws_subnets.private-subnets-tf[*].ids
}

#DB instance address
output "db-address" {
    value = aws_db_instance.mysql.address
}