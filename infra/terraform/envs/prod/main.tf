resource "azurerm_resource_group" "p2_prod" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "p2_acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.p2_prod.name
  location            = azurerm_resource_group.p2_prod.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "p2_law" {
  name                = var.log_analytics_name
  location            = azurerm_resource_group.p2_prod.location
  resource_group_name = azurerm_resource_group.p2_prod.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "p2_aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.p2_prod.location
  resource_group_name = azurerm_resource_group.p2_prod.name
  dns_prefix          = var.dns_prefix
  tags                = var.tags

  api_server_access_profile {
    authorized_ip_ranges = []
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size

    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
  }

  oms_agent {
    log_analytics_workspace_id     = azurerm_log_analytics_workspace.p2_law.id
    msi_auth_for_monitoring_enabled = true
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  lifecycle {
    ignore_changes = [
      api_server_access_profile,
    ]
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.p2_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.p2_aks.kubelet_identity[0].object_id
}
