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
