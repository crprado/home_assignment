provider "azurerm" {
  version = "=2.13.0"

  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "${var.env}_${var.kube_cluster_name}"
  location   = var.azure_region
  dns_prefix = "${var.env}-${var.kube_cluster_dns_prefix}"

  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = var.kube_version

  default_node_pool {
    name       = "${var.env}${var.node_pool_prefix}"
    node_count = var.node_pool_count
    vm_size    = var.node_vm_sku
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "environment" = var.env
  }
}

#This resource could already exist, so granting permssions can be done as an input below
resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true

  depends_on = [ azurerm_resource_group.rg ]
}

data "azurerm_user_assigned_identity" "default" {
  name                = "${azurerm_kubernetes_cluster.cluster.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
}

resource "azurerm_role_assignment" "kube_sp_registration" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azurerm_user_assigned_identity.default.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_public_ip" "external" {
  name                = "${var.env}_${var.external_ip_resource}"
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    "environment" = var.env
  }


}

output "public_ip" {
  value = azurerm_public_ip.external.ip_address
}