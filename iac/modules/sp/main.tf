terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.70.0"
    }
  }
}

provider "azurerm" {
	features {}
}

resource "azuread_application" "control" {
  display_name = "control"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "control" {
  application_object_id = azuread_application.control.object_id
}

resource "azuread_service_principal" "control" {
  application_id               = azuread_application.control.application_id
  app_role_assignment_required = false
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "control" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         =  azuread_service_principal.control.object_id
}

