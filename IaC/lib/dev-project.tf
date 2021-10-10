
resource "azuredevops_project" "project" {
  name       = "nhl"
  description        = "Project Description"
#  visibility         = "public"
  visibility         = "private"
}

data "azuredevops_agent_pool" "pool" {
  name = "Default"
}

data "azuredevops_agent_queue" "mshosted" {
  project_id = azuredevops_project.project.id 
  name = "Azure Pipelines"
}

data "azuredevops_agent_queue" "queue" {
  project_id    = azuredevops_project.project.id
  name = "Default"
}

resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.queue.id
  type        = "queue"
  authorized  = true
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

resource "azuredevops_build_definition" "fe_dev" {
  project_id = azuredevops_project.project.id
  name       = "fe_dev"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "dev"
    yml_path              = "front-end/azure-fe-dev.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }

  variable_groups = [ azuredevops_variable_group.acr.id ]

}

resource "azuredevops_build_definition" "fe_prod" {
  project_id = azuredevops_project.project.id
  name       = "fe_prod"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "main"
    yml_path              = "front-end/azure-fe-prod.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }

  variable_groups = [ azuredevops_variable_group.acr.id ]

}

resource "azuredevops_build_definition" "be_dev" {
  project_id = azuredevops_project.project.id
  name       = "be_dev"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "dev"
    yml_path              = "back-end/azure-be-dev.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }

  variable_groups = [ azuredevops_variable_group.acr.id ]

}

resource "azuredevops_build_definition" "be_prod" {
  project_id = azuredevops_project.project.id
  name       = "be_prod"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "main"
    yml_path              = "back-end/azure-be-prod.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }

  variable_groups = [ azuredevops_variable_group.acr.id ]

}

resource "azuredevops_build_definition" "helm_dev" {
  project_id = azuredevops_project.project.id
  name       = "helm_dev"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "dev"
    yml_path              = "helm/azure-helm-dev.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }
}

resource "azuredevops_build_definition" "helm_prod" {
  project_id = azuredevops_project.project.id
  name       = "helm_prod"
#  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "Qutianer/dev-nhl"
    branch_name           = "main"
    yml_path              = "helm/azure-helm-prod.yml"
    service_connection_id = azuredevops_serviceendpoint_github.qutianer.id
  }
}

module "keyvault" {
  source = "./key_vault"

azurerm_resource_group_location = data.azurerm_resource_group.main.location
azurerm_resource_group_name = data.azurerm_resource_group.main.name
azurerm_tenant_id = var.tenant_id
objects_id = var.client_id
certkey = var.certkey
certcrt = var.certcrt
  
}

resource "local_file" "devops_variables" {
 content = jsonencode({
	project_id = azuredevops_project.project.id
	project_name = azuredevops_project.project.name

#	queuee_id = data.azuredevops_agent_queue.queue.id
	queuee_id = data.azuredevops_agent_queue.mshosted.id

	github_sc = azuredevops_serviceendpoint_github.qutianer.id
	azurerm_sc = azuredevops_serviceendpoint_azurerm.main.id

	k8s_dev_sc = azuredevops_serviceendpoint_kubernetes.dev.id
	k8s_prod_sc = azuredevops_serviceendpoint_kubernetes.prod.id

	helm_dev_artifact_id = azuredevops_build_definition.helm_dev.id
	fe_dev_artifact_id = azuredevops_build_definition.fe_dev.id
	be_dev_artifact_id = azuredevops_build_definition.be_dev.id

	helm_prod_artifact_id = azuredevops_build_definition.helm_prod.id
	fe_prod_artifact_id = azuredevops_build_definition.fe_prod.id
	be_prod_artifact_id = azuredevops_build_definition.be_prod.id

	variable_group = azuredevops_variable_group.db_dev.id
	variable_group = azuredevops_variable_group.db_prod.id


})

 filename = "devops_vars.tfvars"
}

