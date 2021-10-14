resource "azurerm_key_vault" "main" {
  name                        = var.name
  location                    = var.azurerm_resource_group_location
  resource_group_name         = var.azurerm_resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = var.azurerm_tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
  access_policy {
    tenant_id = var.azurerm_tenant_id
    object_id = "53b52726-810c-4579-a761-9977243338a3"

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "List"
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }
  access_policy {
    tenant_id = var.azurerm_tenant_id
    object_id = "22c2882a-9c15-4bfd-9241-0adcdddb36a1"

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get", "List", "Backup", "Delete", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "key" {
  name         = var.keysecretname
  value        = var.certkey
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "cert" {
  name         = var.crtsecretname
  value        = var.certcrt
  key_vault_id = azurerm_key_vault.main.id
}
