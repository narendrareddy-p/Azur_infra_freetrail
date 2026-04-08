resource "azurerm_key_vault" "devops" {

    name = "Devops-SRE"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location
    sku_name = "standard"
    tenant_id = "1e9ee4a6-43c3-4ee4-9e2c-f2c1ff322e3a"
  
}
resource "azurerm_key_vault_secret" "secret" {
  name = "devops"
  value = "Narendra@19"
  key_vault_id = azurerm_key_vault.devops.id
}