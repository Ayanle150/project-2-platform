resource "azurerm_resource_group" "p2_dev" {
  name     = "p2-rg-dev"
  location = "norwayeast"
}

resource "azurerm_container_registry" "p2_acr" {
  name                = "p2acr1769708251"
  resource_group_name = azurerm_resource_group.p2_dev.name
  location            = azurerm_resource_group.p2_dev.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_log_analytics_workspace" "p2_law" {
  name                = "p2-law-1769788039"
  location            = azurerm_resource_group.p2_dev.location
  resource_group_name = azurerm_resource_group.p2_dev.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "p2_aks" {
  name                = "aks-p2-dev"
  location            = azurerm_resource_group.p2_dev.location
  resource_group_name = azurerm_resource_group.p2_dev.name
  dns_prefix          = "aks-p2-dev-p2-rg-dev-1e6c44"
  image_cleaner_enabled           = false
  image_cleaner_interval_hours    = 48

  api_server_access_profile {
    authorized_ip_ranges = []
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "nodepool1"
    node_count = 1

    vm_size    = "Standard_D8lds_v5"
    os_disk_type = "Ephemeral"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.p2_law.id
    msi_auth_for_monitoring_enabled = true
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWwniqt5G/A6KaQz174EpGSdIr6OPKsb4bETtAQpipXyFJr160J/DP+oVIEBPvTPm5bIC9BBNREEDasdTPfToS8y073o6RVRA2WpYZz95W/jEOcCLC7IZE+gi8LycmoZLVNeC38bii0d58+vXMHgq3/4mwMqALmdq/Z56fYv6hgL3+uMiAWzgwKACauisjSyeEn6K2+FQrILQ6+gOHgjuyCW6aKweIeKPzLDChikvvGFf3YWK941mVRFAjwYG4eacQpYGUMmenHIxMbU2ZgA0EgnLG32Qa03JWUh1mARKt+aL4NYzlVp/e1WYZUJU2dHzQ5p/1L7vOGn+NlJ8LbdFb"
    }
  }

  lifecycle {
    ignore_changes = [
      api_server_authorized_ip_ranges,
      api_server_access_profile,
      image_cleaner_enabled,
      image_cleaner_interval_hours,
    ]
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.p2_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.p2_aks.kubelet_identity[0].object_id
}
