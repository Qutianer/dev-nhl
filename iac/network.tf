data "azurerm_virtual_network" "main" {
  name                = "main"
  resource_group_name = local.rg_name
}

resource "azurerm_subnet" "k8s-dev" {
  name                 = "k8s-dev"
  resource_group_name  = local.rg_name
  virtual_network_name = data.azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "k8s-prod" {
  name                 = "k8s-prod"
  resource_group_name  = local.rg_name
  virtual_network_name = data.azurerm_virtual_network.main.name
  address_prefixes     = ["10.2.0.0/16"]
}

