variable "aks_clusters" {
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = string
    default_node_pool = object({
      name       = string
      node_count = number
      vm_size    = string
    })
    identity = list(object({
      type = string
    }))
    network_profile = list(object({
      network_plugin    = string
      load_balancer_sku = string
    }))
    tags = map(string)
  }))
}

resource "azurerm_kubernetes_cluster" "this" {
  for_each            = var.aks_clusters
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }

  dynamic "identity" {
    for_each = each.value.identity
    content {
      type = identity.value.type
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile
    content {
      network_plugin    = network_profile.value.network_plugin
      load_balancer_sku = network_profile.value.load_balancer_sku
    }
  }

  tags = each.value.tags
}

output "aks_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.id }
}
