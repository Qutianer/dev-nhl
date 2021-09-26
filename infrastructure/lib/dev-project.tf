
resource "azuredevops_project" "project" {
  name       = "project"
  description        = "Project Description"
  visibility         = "public"
}

resource "azuredevops_serviceendpoint_github" "github_repo" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "qutianer_pat"
  description = ""

  auth_personal {
    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
    personal_access_token = var.github_pat
  }
}

resource "azuredevops_resource_authorization" "github_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.github_repo.id
  authorized  = true
}

resource "azuredevops_build_definition" "dev_release" {
  project_id = azuredevops_project.project.id
  name       = "dev_release"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
#    github_enterprise_url = "https://github.company.com"
    branch_name           = "dev"
    yml_path              = "azure-pipelines.yml"
    service_connection_id = azuredevops_serviceendpoint_github.github_repo.id
  }

}
