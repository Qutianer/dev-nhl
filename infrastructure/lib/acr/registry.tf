resource "azurerm_container_registry" "acr" {
  name                = "acrzt2fx0ax"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}

