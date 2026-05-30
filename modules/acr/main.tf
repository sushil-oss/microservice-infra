variable "acrs" {
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string
    admin_enabled       = bool
    tags                = map(string)
  }))
}

resource "azurerm_container_registry" "this" {
  for_each            = var.acrs
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled
  tags                = each.value.tags
}

output "acr_login_servers" {
  value = { for k, v in azurerm_container_registry.this : k => v.login_server }
}
