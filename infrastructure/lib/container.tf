variable "azp_token" {
sensitive = true
}


resource "azurerm_container_group" "main" {
  name                = "continst"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = "public"
  dns_name_label      = "aci-ktkq"
  os_type             = "Linux"

  container {
    name   = "azureagent"
    image  = "cywl/azureagent:latest"
    cpu    = "0.5"
    memory = "1"
    environment_variables = {
       AZP_URL = "https://dev.azure.com/vujo3"
       AZP_AGENT_NAME = "mydockeragent"
    }

    secure_environment_variables = {
       AZP_TOKEN=var.azp_token
    }

   ports {
     port     = 443
     protocol = "TCP"
   }
  }

  tags = {
    environment = "testing"
  }
}
