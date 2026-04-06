## Resource Group

resource "azurerm_resource_group" "devops" {
  name     = "Devops-infra"
  location = "East US"
  tags = {
    Environment = "Dev"
    Project = "Demo"
    Owner = "Nare"
  }
}

## Storage account
resource "azurerm_storage_account" "devopsstorage996697" {
  name                     = "devopsstorage996697"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
## Container
resource "azurerm_storage_container" "devops-infra" {
  name                  = "devops-infra"
  storage_account_name    = azurerm_storage_account.devopsstorage996697.name
  container_access_type = "private"
}
## Blob
resource "azurerm_storage_blob" "example" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.devopsstorage996697.name
  storage_container_name = azurerm_storage_container.devops-infra.name
  type                   = "Block"
  source                 = "some-local-file.zip"
}