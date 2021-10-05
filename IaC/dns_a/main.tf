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
}

data "azurerm_resource_group" "main" {
  name     = "main"
}

