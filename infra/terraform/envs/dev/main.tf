resource "azurerm_resource_group" "p2_dev" {
  name     = "rg-p2-dev"
  location = "norwayeast"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_container_registry" "p2_acr" {
  name                = "p2acrdev${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.p2_dev.name
  location            = azurerm_resource_group.p2_dev.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "p2_aks" {
  name                = "aks-p2-dev"
  location            = azurerm_resource_group.p2_dev.location
  resource_group_name = azurerm_resource_group.p2_dev.name
  dns_prefix          = "p2dev"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "system"
    node_count = 1

    # Azure for Students (norwayeast) allows v2, not Standard_B2s
    vm_size    = "Standard_B2s_v2"
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.p2_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.p2_aks.kubelet_identity[0].object_id
}
