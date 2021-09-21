
resource "azurerm_kubernetes_cluster" "dev" {
  name                = "aks-dev"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "aks-dev"

  default_node_pool {
    name       = "mainpool"
    enable_auto_scaling = "true"
    node_count = 1
    min_count = 1
    max_count = 3
    vm_size    = "Standard_D2_v2"
  }

  http_application_routing {
    enable = "true"
  }
 
  service_principal {
    client_id = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Production"
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

