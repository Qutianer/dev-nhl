resource "azuredevops_serviceendpoint_kubernetes" "dev" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "kubernetes_dev"
  apiserver_url         = azurerm_kubernetes_cluster.dev.kube_config.0.host
  authorization_type    = "Kubeconfig"
  kubeconfig {
    kube_config         = azurerm_kubernetes_cluster.dev.kube_config_raw
  }
}

resource "azuredevops_resource_authorization" "k8s_dev" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_kubernetes.dev.id
  authorized  = true
}

resource "azuredevops_serviceendpoint_kubernetes" "prod" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "kubernetes_prod"
  apiserver_url         = azurerm_kubernetes_cluster.prod.kube_config.0.host
  authorization_type    = "Kubeconfig"
  kubeconfig {
    kube_config         = azurerm_kubernetes_cluster.prod.kube_config_raw
  }
}

resource "azuredevops_resource_authorization" "k8s_prod" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_kubernetes.prod.id
  authorized  = true
}

