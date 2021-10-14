resource "azuredevops_variable_group" "db_dev" {
  project_id   = azuredevops_project.project.id
  name         = "db-dev"
  description  = ""
  allow_access = true

  variable {
    name  = "dbhost"
    value = azurerm_mariadb_server.dev.fqdn
  }

  variable {
    name  = "dbname"
    value = azurerm_mariadb_database.dev.name
  }

  variable {
    name  = "dbuser"
    value = "${azurerm_mariadb_server.dev.administrator_login}@${azurerm_mariadb_server.dev.name}"
  }

  variable {
    name         = "dbpass"
    secret_value = azurerm_mariadb_server.dev.administrator_login_password
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "db_prod" {
  project_id   = azuredevops_project.project.id
  name         = "db-prod"
  description  = ""
  allow_access = true

  variable {
    name  = "dbhost"
    value = azurerm_mariadb_server.prod.fqdn
  }

  variable {
    name  = "dbname"
    value = azurerm_mariadb_database.prod.name
  }

  variable {
    name  = "dbuser"
    value = "${azurerm_mariadb_server.prod.administrator_login}@${azurerm_mariadb_server.prod.name}"
  }

  variable {
    name         = "dbpass"
    secret_value = azurerm_mariadb_server.prod.administrator_login_password
    is_secret    = true
  }
}

resource "azuredevops_variable_group" "acr" {
  project_id   = azuredevops_project.project.id
  name         = "acr"
  description  = ""
  allow_access = true

  variable {
    name  = "acr-host"
    value = azurerm_container_registry.acr.login_server
  }

  variable {
    name  = "acr-user"
    value = var.client_id
  }

  variable {
    name  = "acr-pass"
    value = var.client_secret
#    is_secret = true
  }

}

