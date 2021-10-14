resource "azuredevops_variable_group" "db-dev" {
  project_id   = azuredevops_project.project.id
  name         = "db-dev"
  description  = ""
  allow_access = true

  variable {
    name  = "dbhost"
    value = 1
  }

  variable {
    name  = "dbname"
    value = 2
  }

  variable {
    name  = "dbuser"
    value = 3
  }

  variable {
    name         = "dbpass"
    secret_value = 4
    is_secret    = true
  }
}

