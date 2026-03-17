provider "azurerm" {
  features {}
}
module "resource_group" {

  source = "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  resource_group_name   =    "rg-dev-demo"
  location              =   "eastus"
}

/*
module "resource_group_prod" {

  source = "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  resource_group_name = "rg-prod-demo"
  location            = "eastus"
}
*/


module "network" {
  source   = "git::https://github.com/narendrareddy-p/modules.git//virtual-network?ref=feature"
  vnet_name = aks-vnet
  location  = eastus
   resource_group_name  = rg-dev-demo
}

module "aks" {
  source    = "git::https://github.com/narendrareddy-p/modules.git//aks?ref=feature"
  aks_name  = dev-aks
  location  = eastus
  resource_group_name   = rg-dev-demo
  subnet_id = module.network.subnet_id
}
