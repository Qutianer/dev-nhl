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
	subscription_id = var.subscription_id
	tenant_id = var.tenant_id
	client_id = var.client_id
	client_secret = var.client_secret
}

data "azurerm_resource_group" "main" {
  name     = "main"
}

data "azurerm_virtual_network" "main" {
  name                = "main"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = data.azurerm_virtual_network.main.name
}

resource "azurerm_network_interface" "k8s-node" {
  name                = "k8s-node-${count.index}"
  count = 2
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "k8s-node" {
  name = "k8s-node-${count.index}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  count               = 2
  network_interface_ids = [
    azurerm_network_interface.k8s-node[count.index].id,
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
    app="k8s_node"
  }
}

}
