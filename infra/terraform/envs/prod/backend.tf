terraform {
  backend "azurerm" {
    # Update these to your prod state storage values
    resource_group_name  = "p2-rg-tfstate-prod"
    storage_account_name = "p2tfstateprod1769792609"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
