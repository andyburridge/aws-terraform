# ----------------
# Output file to export full NetBox Instance details, for further usage within calling Terraform plan.
#
# Andrew Burridge - 11/2021
# ----------------

output "netbox_server_details" {
    value = aws_instance.netbox_server
    description = "Netbox Server Details"
}