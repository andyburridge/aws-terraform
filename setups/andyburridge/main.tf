provider "aws" {
    region = "eu-west-2"
    profile = "andrewburridge-default"
}

# ----------------
#    Variables
# ----------------

variable "management_subnet_1_prefix" {
    description = "CIDR block for management subnet 1"
}

variable "management_subnet_2_prefix" {
    description = "CIDR block for management subnet 2"
}

# ----------------
#    Resources
# ----------------

resource "aws_vpc" "management_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
      Name = "management_vpc"
  }
}

resource "aws_internet_gateway" "management_igw" {
  vpc_id = aws_vpc.management_vpc.id

  tags = {
    Name = "management_igw"
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
    Name = "management_route_table"
  }
}

resource "aws_subnet" "management_subnet_1" {
  vpc_id     = aws_vpc.management_vpc.id
  cidr_block = var.management_subnet_1_prefix
  availability_zone = "eu-west-2a"

  tags = {
    Name = "management_subnet_1"
  }
}

resource "aws_subnet" "management_subnet_2" {
  vpc_id     = aws_vpc.management_vpc.id
  cidr_block = var.management_subnet_2_prefix
  availability_zone = "eu-west-2b"

  tags = {
    Name = "management_subnet_2"
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


# ----------------
#    Modules
# ----------------

module "management_netbox_server" {
    source = "../../modules/netbox_server"
    ami = "ami-0fdf70ed5c34c5f52"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    ssh_key = "management-servers-key"
    server_name = "netbox_server_1"
    vpc_id = aws_vpc.management_vpc.id
    subnet_id = aws_subnet.management_subnet_1.id
    nic_private_ip =  ["10.0.1.50"]
    eip_dependencies = [aws_internet_gateway.management_igw]
}

# ----------------
#    Outputs
# ----------------


output "netbox_server_public_ip" {
     value = module.management_netbox_server.netbox_server_details.public_ip
}
 
output "netbox_server_private_ip" {
    value = module.management_netbox_server.netbox_server_details.private_ip
}
 
output "netbox_server_id" {
    value = module.management_netbox_server.netbox_server_details.id
}

