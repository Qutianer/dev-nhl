terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.70.0"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azurerm" {
	features {}
}

/**/
data "azurerm_resource_group" "main" {
  name     = "main"
}
/**/

/**
resource "azurerm_resource_group" "main" {
  name     = "main"
  location = "North Europe"
}
/**/

provider "azuredevops" {
	org_service_url = "https://dev.azure.com/vujo3"
	personal_access_token = var.azure_devops_pat
}

