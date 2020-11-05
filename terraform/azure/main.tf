terraform {
  required_version = "~> 0.11"
}

provider "azurerm" {}

resource "azurerm_resource_group" "vault" {
  name     = "vault-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vault" {
  name                = "vault-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vault.name}"
}

resource "azurerm_subnet" "vault" {
  name                 = "vault-subnet"
  virtual_network_name = "${azurerm_virtual_network.vault.name}"
  resource_group_name  = "${azurerm_resource_group.vault.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_public_ip" "vault" {
  name                = "vault-ip"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vault.name}"
  allocation_method   = "Static" # Case Sensitive
}

resource "azurerm_network_security_group" "vault" {
  name                = "vault-network-security-group"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vault.name}"
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "vault-ssh-nsg-rule"
  resource_group_name         = "${azurerm_resource_group.vault.name}"
  network_security_group_name = "${azurerm_network_security_group.vault.name}"
  priority                    = 100
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "api" {
  name                        = "vault-api-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.vault.name}"
  resource_group_name         = "${azurerm_resource_group.vault.name}"
  priority                    = 110
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8200"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "server" {
  name                        = "vault-server-nsg-rule"
  network_security_group_name = "${azurerm_network_security_group.vault.name}"
  resource_group_name         = "${azurerm_resource_group.vault.name}"
  priority                    = 120
  direction                   = "inbound"
  access                      = "allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "8201"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface" "vault" {
  name                      = "vault-network-interface"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.vault.name}"
  network_security_group_id = "${azurerm_network_security_group.vault.id}"

  ip_configuration {
    name                          = "vault-server-public-ip-configuration"
    subnet_id                     = "${azurerm_subnet.vault.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vault.id}"
  }
}

resource "azurerm_virtual_machine" "vault" {
  name                             = "vault-server-virtual-machine"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.vault.name}"
  network_interface_ids            = ["${azurerm_network_interface.vault.id}"]
  vm_size                          = "standard_e4s_v3"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical" # Case Sensitive
    offer     = "UbuntuServer" # Case Sensitive
    sku       = "16.04-LTS" # Case Sensitive
    version   = "latest"
  }

  storage_os_disk {
    name              = "vault-server-disk-1"
    caching           = "ReadWrite" # Case Sensitive
    create_option     = "fromimage"
    managed_disk_type = "Standard_LRS" # Case Sensitive
    disk_size_gb      = 100
  }

  os_profile {
    computer_name  = "vault-server"
    admin_username = "ubuntu" # root is not allowed
    admin_password = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file(var.ssh_key_file)}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.init_server.rendered}"
    destination = "${var.config_destination_dir}/init.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
    }
  }
}

data "template_file" "init_server" {
  template = "${file("${path.module}/templates/init_server.sh.tpl")}"
  vars {
    binary_filename = "${var.vault_binary_filename}"
    binary_url      = "${var.vault_binary_url}"
  }
}