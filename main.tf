resource "azurerm_resource_group" "devops" {
  name     = "Devops-infra"
  location = "East US"
  tags = {
    Environment = "Dev"
    Project = "Demo"
    Owner = "Nare"
  }
}


resource "azurerm_storage_account" "devops_storage996697" {
  name                     = "devops_storage996697"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}