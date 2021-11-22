# ----------------
# Module to create an VPC with 2 x Subnets in different Availability Zones, in addition to a custom Route Table with IGW breakout and Subnet associations. 
#
# Andrew Burridge - 11/2021
# ----------------


terraform {
    required_version = ">= 1.0.11"
}


# ----------------
#    Resources
# ----------------

resource "aws_vpc" "management_vpc" {
  cidr_block = var.vpc_prefix

  tags = {
      Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "management_igw" {
  vpc_id = aws_vpc.management_vpc.id

  tags = {
    Name = var.internet_gw_name
  }
}

resource "aws_route_table" "management_route_table" {
  vpc_id = aws_vpc.management_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.management_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.management_igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_subnet" "management_subnet_1" {
  vpc_id     = aws_vpc.management_vpc.id
  cidr_block = var.subnet_1_prefix
  availability_zone = var.subnet_1_availability_zone

  tags = {
    Name = var.subnet_1_name
  }
}

resource "aws_subnet" "management_subnet_2" {
  vpc_id     = aws_vpc.management_vpc.id
  cidr_block = var.subnet_2_prefix
  availability_zone = var.subnet_2_availability_zone

  tags = {
    Name = var.subnet_2_name
  }
}

resource "aws_route_table_association" "management_subnet_1" {
  subnet_id      = aws_subnet.management_subnet_1.id
  route_table_id = aws_route_table.management_route_table.id
}

resource "aws_route_table_association" "management_subnet_2" {
  subnet_id      = aws_subnet.management_subnet_2.id
  route_table_id = aws_route_table.management_route_table.id
}