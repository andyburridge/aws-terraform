# ----------------
# Module to create an AWS Instance with an ENI and Elastic IP, together with an appropriate Security Group for running NetBox Docker.
# Downloads and installs NetBox docker by applying the 'build.sh' script as Instance User Data, making it available on port TCP/8000.
#
# Andrew Burridge - 11/2021
# ----------------


terraform {
    required_version = ">= 1.0.11"
}

# ----------------
#    Data
# ----------------

data template_file "netbox_server_build_data" {
    template = "${file("../../modules/instance_netbox_server/build.sh")}"
}


# ----------------
#    Resources
# ----------------

resource "aws_security_group" "allow_netbox_web" {
  name        = "allow_netbox_web"
  description = "Allow web traffic for NetBox docker"
  vpc_id      = var.vpc_id

  ingress {
    description      = "NetBox web server"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_netbox_web"
  }
}

resource "aws_instance" "netbox_server" {
  ami                  = var.ami 
  instance_type        = var.instance_type
  availability_zone    = var.availability_zone
  key_name             = var.ssh_key
  iam_instance_profile = "netbox-backup" 
  
  network_interface {
      device_index          = 0
      network_interface_id  = aws_network_interface.netbox_server_nic.id
  }  

  user_data = "${data.template_file.netbox_server_build_data.rendered}"

  tags = {
      Name = "${var.server_name}"
  }
}

resource "aws_network_interface" "netbox_server_nic" {
  subnet_id       = var.subnet_id
  private_ips     = var.nic_private_ip
  security_groups = [aws_security_group.allow_netbox_web.id]
}

resource "aws_eip" "netbox_server_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.netbox_server_nic.id
  associate_with_private_ip = var.nic_private_ip[0]
  depends_on                = [var.eip_dependencies]
}
