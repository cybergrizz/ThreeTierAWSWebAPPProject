#List of available availability zones in given region
output "list_of_az" {
  value = data.aws_availability_zones.available-azs[*].names
}

#List of public subnet IDs
output "public_subnet_id" {
  value = data.aws_subnet.public-tf[*].ids
}

#List of private subnet IDs
output "private_subnet_id" {
  value = data.aws_subnet.private-tf[*].ids
}

#DB instance address
output "db-address" {
    value = aws_db_instance.db-instance.address
}