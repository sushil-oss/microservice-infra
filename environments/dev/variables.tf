variable "infrastructure_dev" {
  description = "Configuration for Dev environment"
  type = map(object({
    location            = string
    resource_group_name = string
    acr_name            = string
    acr_sku             = string
    acr_admin_enabled   = bool
    aks_name            = string
    aks_dns_prefix      = string
    aks_version         = string
    aks_default_node_pool = object({
      name       = string
      node_count = number
      vm_size    = string
    })
    aks_identity = list(object({
      type = string
    }))
    aks_network_profile = list(object({
      network_plugin    = string
      load_balancer_sku = string
    }))
    tags = map(string)
  }))
}
