output "dev_resource_groups" {
  value = module.resource_groups.resource_group_names
}

output "dev_acr_logins" {
  value = module.acrs.acr_login_servers
}

output "dev_aks_ids" {
  value = module.aks_clusters.aks_ids
}
