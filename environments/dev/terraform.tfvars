infrastructure_dev = {
  "microservice_app" = {
    location            = "East US"
    resource_group_name = "rg-dev-microservice"
    acr_name            = "acrdevmicroservice001"
    acr_sku             = "Basic"
    acr_admin_enabled   = true
    aks_name            = "aks-dev-microservice"
    aks_dns_prefix      = "aksdev"
    aks_version         = "1.34"
    aks_default_node_pool = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_DS2_v2"
    }
    aks_identity = [
      {
        type = "SystemAssigned"
      }
    ]
    aks_network_profile = [
      {
        network_plugin    = "azure"
        load_balancer_sku = "standard"
      }
    ]
    tags = {
      environment = "dev"
      project     = "microservice-infra"
    }
  }
}
