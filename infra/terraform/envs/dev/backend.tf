terraform {
  backend "azurerm" {
    resource_group_name  = "rg-p2-tfstate"
    storage_account_name = "p2tfstate1769006775"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
