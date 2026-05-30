terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatedev001" # This must be globally unique
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "resource_groups" {
  source = "../../modules/resource_group"
  
  resource_groups = {
    for k, v in var.infrastructure_dev : v.resource_group_name => {
      location = v.location
      tags     = v.tags
    }
  }
}

module "acrs" {
  source     = "../../modules/acr"
  depends_on = [module.resource_groups]

  acrs = {
    for k, v in var.infrastructure_dev : v.acr_name => {
      resource_group_name = v.resource_group_name
      location            = v.location
      sku                 = v.acr_sku
      admin_enabled       = v.acr_admin_enabled
      tags                = v.tags
    }
  }
}

module "aks_clusters" {
  source     = "../../modules/aks"
  depends_on = [module.resource_groups]

  aks_clusters = {
    for k, v in var.infrastructure_dev : v.aks_name => {
      resource_group_name = v.resource_group_name
      location            = v.location
      dns_prefix          = v.aks_dns_prefix
      kubernetes_version  = v.aks_version
      default_node_pool   = v.aks_default_node_pool
      identity            = v.aks_identity
      network_profile     = v.aks_network_profile
      tags                = v.tags
    }
  }
}
