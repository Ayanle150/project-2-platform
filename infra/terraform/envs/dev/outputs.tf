output "resource_group_name" {
  value = azurerm_resource_group.p2_dev.name
}

output "acr_name" {
  value = azurerm_container_registry.p2_acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.p2_acr.login_server
}
