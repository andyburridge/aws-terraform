# ----------------
# Variables file associated with NetBox Instance module.
#
# Andrew Burridge - 11/2021
# ----------------

variable "ami" {
    type = string
    description = "Instance AMI"
}

variable "instance_type" {
    type = string
    description = "Instance Type"
}

variable "availability_zone" {
    type = string
    description = "Instance Availability Zone"
}

variable "ssh_key" {
    type = string
    description = "Instance SSH Key"
}

variable "subnet_id" {
    type = string
    description = "Instance Subnet ID"
}

variable "vpc_id" {
    type = string
    description = "Instance VPC ID"
}

variable "nic_private_ip" {
    type = list
    description = "Instance NIC Private IP Address"
}

variable "eip_dependencies" {
    type = list
    description = "Instance EIP Dependencies"
}

variable "server_name" {
    type = string
    description = "Instance Server Name"
}