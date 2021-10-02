resource "azuredevops_variable_group" "db-dev" {
  project_id   = azuredevops_project.project.id
  name         = "db-dev"
  description  = ""
  allow_access = true

  variable {
    name  = "dbhost"
    value = azurerm_mariadb_server.main.fqdn
  }

  variable {
    name  = "dbname"
    value = azurerm_mariadb_database.dev.name
  }

  variable {
    name  = "dbuser"
    value = "${azurerm_mariadb_server.main.administrator_login}@${azurerm_mariadb_server.main.name}"
  }

  variable {
    name         = "dbpass"
    secret_value = azurerm_mariadb_server.main.administrator_login_password
    is_secret    = true
  }
}
