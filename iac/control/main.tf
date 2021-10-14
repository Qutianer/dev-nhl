terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.70.0"
    }
  }
}

provider "azurerm" {
	features {}
}

data "azurerm_resource_group" "main" {
  name     = "main"
#  location = "North Europe"
}

locals {
  rg_name = data.azurerm_resource_group.main.name
  rg_location = data.azurerm_resource_group.main.location
}

resource "azurerm_virtual_network" "main" {
  name                = "main"
  address_space       = ["192.168.0.0/16"]
  resource_group_name = local.rg_name
  location            = local.rg_location
}

resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                    = "pubip"
  resource_group_name     = local.rg_name
  location                = local.rg_location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "control" {
  name                = "control"
  resource_group_name = local.rg_name
  location            = local.rg_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id	  = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "control" {
  name                = "control-node"
  resource_group_name = local.rg_name
  location            = local.rg_location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.control.id,
  ]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }
  tags = {
    app="control"
  }
}
