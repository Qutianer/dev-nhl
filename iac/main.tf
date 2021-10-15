terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.70.0"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "=0.1.7"
    }
  }
}

provider "azurerm" {
	features {}
}

provider "azuredevops" {
	org_service_url = "https://dev.azure.com/vujo3"
	personal_access_token = var.azure_devops_pat
}

