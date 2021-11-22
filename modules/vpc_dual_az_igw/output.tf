# ----------------
# Output file to export full VPC, Subnet, IGW and Route Table details, for further usage within calling Terraform plan.
#
# Andrew Burridge - 11/2021
# ----------------

output "vpc_details" {
    value = aws_vpc.management_vpc
    description = "VPC Details"
}

output "subnet-1_details" {
    value = aws_subnet.management_subnet_1
    description = "Subnet #1 Details"
}

output "subnet-2_details" {
    value = aws_subnet.management_subnet_2
    description = "Subnet #2 Details"
}

output "igw_details" {
    value = aws_internet_gateway.management_igw
    description = "IGW Details"
}

output "route_table_details" {
    value = aws_route_table.management_route_table
    description = "Route Table Details"
}