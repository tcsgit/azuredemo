terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "arg" {
    name     = var.resourcename
    location = var.location
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                     = var.registryname
  resource_group_name      = var.resourcename
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = false

  depends_on = [azurerm_resource_group.arg]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.clustername
  location            = var.location
  resource_group_name = var.resourcename
  dns_prefix          = var.dnsprefix

default_node_pool {
    name       = "default"
    node_count = var.nodecount
    vm_size    = var.vmsize
  }

identity {
    type = "SystemAssigned"
  }  

tags = {
    environment = "Demo"
  }

depends_on = [azurerm_resource_group.arg]
}