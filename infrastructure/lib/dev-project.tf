
resource "azuredevops_project" "project" {
  name       = "project"
  description        = "Project Description"
#  visibility         = "public"
  visibility         = "private"
}

resource "azuredevops_serviceendpoint_github" "qutianer" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "qutianer_pat"
  description = ""

  auth_personal {
    personal_access_token = var.github_pat
  }
}

resource "azuredevops_resource_authorization" "github_qutianer" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.qutianer.id
  authorized  = true
}

resource "azuredevops_serviceendpoint_azurerm" "dev" {
  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "kubernetes_dev"
  description = "" 
  azurerm_spn_tenantid      = var.tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = "MySubscription"
}

resource "azuredevops_resource_authorization" "azurerm" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.dev.id
  authorized  = true
}

resource "azuredevops_serviceendpoint_kubernetes" "dev" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Sample Kubernetes"
  apiserver_url         = "https://sample-kubernetes-cluster.hcp.westeurope.azmk8s.io"
  authorization_type    = "AzureSubscription"

  azure_subscription {
    subscription_id   = var.subscription_id
    subscription_name = "MySubscription"
    tenant_id         = var.tenant_id
    resourcegroup_id  = "main"
    namespace         = "default"
    cluster_name      = "ddd"
  }
}

resource "azuredevops_resource_authorization" "k8s" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.dev.id
  authorized  = true
}

data "azuredevops_agent_pool" "pool" {
  name = "Default"
}

data "azuredevops_agent_queue" "queue" {
  project_id    = azuredevops_project.project.id
  name = "Default"
}

# Grant acccess to queue to all pipelines in the project
resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.queue.id
  type        = "queue"
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
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }

}
