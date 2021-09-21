terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.70.0"
    }
  }
}

provider "azurerm" {
	features {}
	subscription_id = var.subscription_id
	tenant_id = var.tenant_id
	client_id = var.client_id
	client_secret = var.client_secret
}

data "azurerm_resource_group" "main" {
  name     = "main"
}

