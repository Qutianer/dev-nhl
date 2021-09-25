
resource "azurerm_kubernetes_cluster" "dev" {
  name                = "aks-dev"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "aks-dev"
  node_resource_group = "aks-dev-nodes"
#  private_dns_zone_id = azurerm_dns_zone.dev.id

  default_node_pool {
    name       = "mainpool"
    enable_auto_scaling = "true"
    node_count = 1
    min_count = 1
    max_count = 3
    vm_size    = "Standard_B2s"
    os_disk_size_gb = "30"
  }

  addon_profile {
    http_application_routing {
      enabled = "true"
    }
  }

  role_based_access_control {
    enabled = "false"
#    enabled = "true"
#    azure_active_directory {
#      managed = "true"
#      admin_group_object_ids = [ "c07da0e9-1e87-40d2-86c1-626cc9c0e2c4" ]
#    }
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
      default_node_pool["node_count"]
    ]
  }
}

resource "local_file" "kube-config" {
 content = <<-EOT
	${azurerm_kubernetes_cluster.dev.kube_admin_config_raw}
EOT
 filename = "config"
}

