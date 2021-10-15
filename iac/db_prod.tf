resource "random_password" "prod_dbadmin_pass" {
  length           = 16
  special          = false
  override_special = "_%@"
}

resource "azurerm_mariadb_server" "prod" {
  name                = "nhl-prod-db-ycmp8cu1"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  administrator_login          = "dbadmin"
  administrator_login_password = random_password.prod_dbadmin_pass.result

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  ssl_enforcement_enabled       = true
}

resource "azurerm_mariadb_firewall_rule" "prod" {
  name                = "allow-azure-svcs"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mariadb_server.prod.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mariadb_database" "prod" {
  name                = "nhl_prod"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mariadb_server.prod.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}
