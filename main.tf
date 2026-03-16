provider "azurerm" {
  features {}
}

module "resource_group" {

  source = "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  name     = var.resource_group_name
  location = var.location
}