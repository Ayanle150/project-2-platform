output "resource_group_name" {
  value = azurerm_resource_group.p2_prod.name
}

output "acr_name" {
  value = azurerm_container_registry.p2_acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.p2_acr.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.p2_aks.name
}
