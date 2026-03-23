
module "resource_group" {

  source =     "git::https://github.com/narendrareddy-p/modules.git//resource-group?ref=feature"
  for_each = var.resource_groups

resource_group_name   = each.value.rg_name
  location = each.value.location
  tags     = each.value.tags
}