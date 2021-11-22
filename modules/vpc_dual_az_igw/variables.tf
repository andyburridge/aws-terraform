# ----------------
# Variables file associated with Terraform plan.
#
# Andrew Burridge - 11/2021
# ----------------


variable "vpc_prefix" {
    type = string
    description = "CIDR block for VPC"
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    description = "VPC Name"
}

variable "subnet_1_name" {
    type = string
    description = "Subnet Name"
}

variable "subnet_1_prefix" {
    type = string
    description = "CIDR block for subnet #1"
    default = "10.0.1.0/24"
}

variable "subnet_1_availability_zone" {
    type = string
    description = "AZ for subnet #1"
    default = "eu-west-2a"
}

variable "subnet_2_name" {
    type = string
    description = "Subnet Name"
}

variable "subnet_2_prefix" {
    type = string
    description = "CIDR block for subnet #2"
    default = "10.0.2.0/24"
}

variable "subnet_2_availability_zone" {
    type = string
    description = "AZ for subnet #2"
    default = "eu-west-2b"
}

variable "internet_gw_name" {
    type = string
    description = "IGW Name"
}

variable "route_table_name" {
    type = string
    description = "Route Table Name"
}