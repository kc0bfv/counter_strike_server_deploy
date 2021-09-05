terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

variable "environ_tag" {
  default = "counterstrike"
}

variable "instance_ami" {
  # Debian 10.7 64bit us-east-2
  # default = "ami-05f5cd6454a382a70"

  # Debian 11 64bit us-east-1
  default = "ami-0a943bffbae98ca20"
}

variable "machine_type" {
  #default = "t3a.large"
  # Choose one with instance storage...
  default = "c5ad.large"
}

variable "ipv4_cidr_block" {
  default = "10.163.0.0/16"
}

variable "subnet_number" {
  default = 0
}

provider "aws" {
  profile = "aws_admin"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block                       = var.ipv4_cidr_block
  assign_generated_ipv6_cidr_block = true

  tags = { Environment = var.environ_tag }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = { Environment = var.environ_tag }
}

resource "aws_subnet" "sub" {
  vpc_id          = aws_vpc.vpc.id
  cidr_block      = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.subnet_number)
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, var.subnet_number)

  map_public_ip_on_launch = true

  tags = { Environment = var.environ_tag }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = { Environment = var.environ_tag }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.sub.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "allow_none" {
  name        = "allow_none"
  description = "Allow Nothing"
  vpc_id      = aws_vpc.vpc.id

  tags = { Environment = var.environ_tag }
}

resource "aws_security_group" "allow_admin" {
  name        = "allow_admin"
  description = "Allow RDP and SSH"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "27000-27021 UDP from anywhere"
    from_port        = 27000
    to_port          = 27021
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "27000-27021 TCP from anywhere"
    from_port        = 27000
    to_port          = 27021
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "26901 UDP from anywhere"
    from_port        = 26901
    to_port          = 26901
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "All Egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Environment = var.environ_tag }
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = file("key.pub")

  tags = { Environment = var.environ_tag }
}

resource "aws_instance" "inst" {
  ami                = var.instance_ami
  instance_type      = var.machine_type
  subnet_id          = aws_subnet.sub.id
  ipv6_address_count = 1
  #get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow_admin.id]
  key_name               = aws_key_pair.key.key_name
  depends_on             = [aws_internet_gateway.igw]

  tags = {
    Environment = var.environ_tag
    Name = "Counterstrike Instance"
  }
}

resource "aws_ebs_volume" "inst_drive" {
  availability_zone = aws_instance.inst.availability_zone
  size              = 50

  tags = { Environment = var.environ_tag }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.inst_drive.id
  instance_id = aws_instance.inst.id
}

/*
output "Administrator_Password" {
  value = rsadecrypt(aws_instance.inst.password_data, file("key"))
}
*/

output "IP_Address" {
  value = aws_instance.inst.public_ip
}
