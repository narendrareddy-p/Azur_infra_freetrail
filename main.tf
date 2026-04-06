resource "azurerm_resource_group" "devops" {
  name     = "Devops-infra"
  location = "East US"
  tags = {
    Environment = "Dev"
    Project = "Demo"
    Owner = "Nare"
  }
}