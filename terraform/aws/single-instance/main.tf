terraform {
  required_version = "~> 0.12"
}

provider "aws" {}

resource "aws_vpc" "vault" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "vault" {
  vpc_id            = aws_vpc.vault.id
  cidr_block        = cidrsubnet(aws_vpc.vault.cidr_block, 3, 1)
  availability_zone = join("", [var.region, "a"])
}

resource "aws_security_group" "vault" {
  name   = "vault-security-group"
  vpc_id = aws_vpc.vault.id
  tags   = {}
}

resource "aws_security_group_rule" "vault_api_ingress_external" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8200
  to_port           = 8200
  cidr_blocks       = var.vault_api_ingress_cidr_blocks
  security_group_id = aws_security_group.vault.id
}

resource "aws_security_group_rule" "vault_ssh_ingress_external" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}

resource "aws_security_group_rule" "vault_egress_external" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}

resource "aws_security_group" "vault_internal" {
  name   = "vault-internal-security-group"
  vpc_id = aws_vpc.vault.id
  tags   = {}
}

resource "aws_security_group_rule" "vault_api_ingress_internal" {
  type              = "ingress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.vault_internal.id
}

resource "aws_security_group_rule" "vault_cluster_ingress_internal" {
  type              = "ingress"
  from_port         = 8201
  to_port           = 8201
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.vault_internal.id
}

resource "aws_security_group_rule" "vault_egress_internal" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.vault_internal.id
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "aws_key_pair" "vault" {
  key_name   = "vault"
  public_key = tls_private_key.default.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh.tpl")}"
  vars = {
    binary_filename = var.vault_binary_filename
    binary_url      = var.vault_binary_url
    cluster_name    = var.cluster_name
  }
}

resource "aws_instance" "vault_primary" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "m4.large"
  subnet_id                   = aws_subnet.vault.id
  user_data                   = data.template_file.user_data.rendered
  key_name                    = aws_key_pair.vault.key_name
  security_groups             = [aws_security_group.vault.id, aws_security_group.vault_internal.id]
  associate_public_ip_address = true
  disable_api_termination     = false
  ebs_optimized               = false
  tags                        = {}
  monitoring                  = false
}

resource "aws_instance" "vault_secondary" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "m4.large"
  subnet_id                   = aws_subnet.vault.id
  user_data                   = data.template_file.user_data.rendered
  key_name                    = aws_key_pair.vault.key_name
  security_groups             = [aws_security_group.vault.id, aws_security_group.vault_internal.id]
  associate_public_ip_address = true
  disable_api_termination     = false
  ebs_optimized               = false
  tags                        = {}
  monitoring                  = false
}

resource "aws_eip" "vault_primary" {
  instance = aws_instance.vault_primary.id
  vpc      = true
}

resource "aws_eip" "vault_secondary" {
  instance = aws_instance.vault_secondary.id
  vpc      = true
}

resource "aws_internet_gateway" "vault" {
  vpc_id = aws_vpc.vault.id
}

resource "aws_route_table" "vault" {
  vpc_id = aws_vpc.vault.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vault.id
  }
}

resource "aws_route_table_association" "vault" {
  subnet_id      = aws_subnet.vault.id
  route_table_id = aws_route_table.vault.id
}
