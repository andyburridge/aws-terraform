# ----------------
# Plan to create a VPC with Subnets in 2 x Availability Zones, a custom Route Table with Internet breakout, and an Instance running NetBox docker.
#
# Andrew Burridge - 11/2021
# ----------------

provider "aws" {
    region = var.region
    profile = var.credentials_profile
}


# ----------------
#    Modules
# ----------------

module "management_vpc" {
    source = "../../modules/vpc_dual_az_igw"
    vpc_prefix = "10.0.0.0/16"
    vpc_name = "management_vpc"
    subnet_1_name = "management_subnet_1"
    subnet_1_prefix = "10.0.1.0/24"
    subnet_1_availability_zone = "eu-west-2a"
    subnet_2_name = "management_subnet_2"
    subnet_2_prefix = "10.0.2.0/24"
    subnet_2_availability_zone = "eu-west-2b"
    internet_gw_name = "management_igw"
    route_table_name = "management_route_table"
}

module "management_netbox_server" {
    source = "../../modules/instance_netbox_server"
    ami = "ami-0fdf70ed5c34c5f52"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    ssh_key = "management-servers-key"
    server_name = "netbox_server_1"
    vpc_id = module.management_vpc.vpc_details.id
    subnet_id = module.management_vpc.subnet-1_details.id
    nic_private_ip =  ["10.0.1.50"]
    eip_dependencies = [module.management_vpc.igw_details]
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

