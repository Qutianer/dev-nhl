resource "azuredevops_serviceendpoint_azurecr" "main" {
  project_id             = azuredevops_project.project.id
  service_endpoint_name  = "acr"
  resource_group            = "main"
  azurecr_spn_tenantid      = var.tenant_id
  azurecr_name              = "acrzt2fx0ax"
  azurecr_subscription_id   = var.subscription_id
  azurecr_subscription_name = "MySubscription"
}

resource "azuredevops_resource_authorization" "acr" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurecr.main.id
  authorized  = true
}

