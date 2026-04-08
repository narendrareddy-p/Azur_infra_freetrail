resource "azurerm_availability_set" "devops" {
  name = "infra"
  resource_group_name = azurerm_resource_group.devops.name
  location = azurerm_resource_group.devops.location
  platform_fault_domain_count = 1
  platform_update_domain_count = 2
  tags = azurerm_resource_group.devops.tags
}