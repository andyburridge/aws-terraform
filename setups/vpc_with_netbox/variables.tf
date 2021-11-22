# ----------------
# Variables file associated with Terraform plan.
#
# Andrew Burridge - 11/2021
# ----------------

variable "region" {
    type = string
    description = "AWS Deployment Region"
    default = "eu-west-2"
}

variable "credentials_profile" {
    type = string
    description = "AWS Credentials Proflie"
    default = "andrewburridge-default"
}