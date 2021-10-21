data "azurerm_virtual_network" "main" {
  name                = "main"
  resource_group_name = local.rg_name
}

data "azurerm_virtual_network" "dev" {
  name                = "aks-vnet-65138751"
  resource_group_name = azurerm_kubernetes_cluster.dev.node_resource_group
}

resource "azurerm_virtual_network_peering" "main-k8s" {
  name                      = "toK8s"
  resource_group_name       = local.rg_name
  virtual_network_name      = data.azurerm_virtual_network.main.name
  remote_virtual_network_id = data.azurerm_virtual_network.dev.id
}

resource "azurerm_virtual_network_peering" "k8s-main" {
  name                      = "toMain"
  resource_group_name       = azurerm_kubernetes_cluster.dev.node_resource_group
  virtual_network_name      = data.azurerm_virtual_network.dev.name
  remote_virtual_network_id = data.azurerm_virtual_network.main.id
}

