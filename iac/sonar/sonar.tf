variable "sonar_server" {}
variable "sonar_project_name" { default="nhl" }
variable "sonar_pat" {}

resource "azuredevops_serviceendpoint_sonarqube" "main" {

  project_id        = azuredevops_project.project.id
  service_endpoint_name = "sonar"
  url                   = var.sonar_server
  token                 = var.sonar_pat
  description           = "Managed by Terraform"
}

resource "azuredevops_resource_authorization" "sonar" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_sonarqube.main.id
  authorized  = true
}

resource "azuredevops_variable_group" "sonar" {
  project_id   = azuredevops_project.project.id
  name         = "sonar"
  description  = ""
  allow_access = true

  variable {
    name  = "sonar_server"
    value = var.sonar_server
  }

  variable {
    name  = "sonar_project"
    value = var.sonar_project_name
  }

  variable {
    name  = "sonar_pat"
    value = var.sonar_pat
  }

}

