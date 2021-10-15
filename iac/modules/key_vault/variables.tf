variable "name" {
	default = "keyvault-531b25k8"
	description = "Key vault name"
}

variable "azurerm_resource_group_location" {}

variable "azurerm_resource_group_name" {}

variable "azurerm_tenant_id" {}




variable "keysecretname" {
	default = "certkey"
	description = "Name of private key secret"
}

variable "crtsecretname" {
	default = "certcrt"
	description = "Name of certificate secret"
}

variable "objects_id" {}
variable "certkey" {}
variable "certcrt" {}

