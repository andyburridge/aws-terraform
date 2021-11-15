provider "aws" {
    region = "eu-west-2"
    profile = "andrewburridge-default"
}

variable "management_subnet_1_prefix" {
    description = "CIDR block for management subnet 1"
}

variable "management_subnet_2_prefix" {
    description = "CIDR block for management subnet 2"
}

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

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.management_vpc.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from VPC"
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
    Name = "allow_we"
  }
}

resource "aws_network_interface" "web_server_nic" {
  subnet_id         =   aws_subnet.management_subnet_1.id
  private_ips       =   ["10.0.1.50"]
  security_groups   =   [aws_security_group.allow_web.id]
}

resource "aws_eip" "web_server_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.web_server_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.management_igw]
}

resource "aws_instance" "web_server" {
  ami                 =   "ami-0fdf70ed5c34c5f52"  
  instance_type       =   "t2.micro"
  availability_zone   =   "eu-west-2a"
  key_name            =   "management-servers-key"
  
  network_interface {
      device_index          =   0
      network_interface_id  =   aws_network_interface.web_server_nic.id
  }  

  user_data = <<-EOF
            #/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo bash -c "echo your very first web server > /var/www/html/index.html"
            EOF

  tags = {
      Name = "management-web_server"
  }
}


output "web_server_public_ip" {
    value = aws_eip.web_server_eip.public_ip
}

output "web_server_private_ip" {
    value = aws_instance.web_server.private_ip
}

output "web_server_id" {
    value = aws_instance.web_server.id
}