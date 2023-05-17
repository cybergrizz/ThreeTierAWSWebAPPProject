data "aws_availability_zones" "available-azs" {
  state = "available"
}

data "aws_subnet" "public-tf" {
  id = var.public_subnets
}

data "aws_subnet" "private-tf" {
  id = var.private_subnets
}

#Create 2 public subnets for webserver tier
resource "aws_subnet" "public-tf" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available-azs.names)[each.value - 1]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-public-${each.key}"
    Tier = "public"
  }
}

#Create 2 private subnets for RDS MySQL tier
resource "aws_subnet" "private-tf" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available-azs.names)[each.value - 1]
  map_public_ip_on_launch = false

  tags = {
    Name = "tf-subnet-private-${each.key}"
    Tier = "private"
  }
}

