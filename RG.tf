
module "resource_group" {

  source =     "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  

  resource_group_name  = var.rg_name
  location = var.location
  tags     = var.tags
}

module "resource_group_devops" {

  source =     "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  

  resource_group_name  = "non-prod-devlopers"
  location = "East US"
  tags     = var.tags
}