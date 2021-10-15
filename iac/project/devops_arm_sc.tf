resource "azuredevops_serviceendpoint_azurerm" "main" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "azurerm"
#  description = "Managed by Terraform" 
  credentials {
    serviceprincipalid  = "981281e4-fe69-4abf-932b-a6f3bffb71fb"
    serviceprincipalkey = var.client_secret
  }
  azurerm_spn_tenantid      = var.tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = "MySubscription"
}

resource "azuredevops_resource_authorization" "azurerm" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.main.id
  authorized  = true
}

