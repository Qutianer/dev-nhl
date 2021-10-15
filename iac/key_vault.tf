module "keyvault" {
  source = "./modules/key_vault"

azurerm_resource_group_location = data.azurerm_resource_group.main.location
azurerm_resource_group_name = data.azurerm_resource_group.main.name
azurerm_tenant_id = var.tenant_id
objects_id = var.client_id
certkey = var.certkey
certcrt = var.certcrt
  
}

