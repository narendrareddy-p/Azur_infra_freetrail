terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

module "resource_group" {

  source = "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  resource_group_name =    "rg-dev-demo"
  location              =   "eastus"
}

/*
module "resource_group_prod" {

  source = "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  resource_group_name = "rg-prod-demo"
  location            = "eastus"
}
*/
