## Resource Group

resource "azurerm_resource_group" "devops" {
  name     = "Devops-infra"
  location = local.resource_location
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
  tags = azurerm_resource_group.devops.tags

}

resource "azurerm_storage_account" "devopsstorage9966970" {
  
  count = 2 ## using count
  name                     = "devopsstorage9966970${count.index}"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = azurerm_resource_group.devops.tags

}
## Container
resource "azurerm_storage_container" "devops-infra" {
  name                  = "devops-infra"
  storage_account_name    = azurerm_storage_account.devopsstorage996697.name
  container_access_type = "private"

}

resource "azurerm_storage_container" "script" {
    count = 3
    name = "script${count.index}"
    storage_account_name = azurerm_storage_account.devopsstorage9966970[1].name
    container_access_type = "private"
  
}

resource "azurerm_storage_container" "script-infra" {
    for_each = var.container
    name = each.value
    storage_account_name = azurerm_storage_account.devopsstorage9966970[1].name
    container_access_type = "private"
  
}
/*
## Blob
resource "azurerm_storage_blob" "example" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.devopsstorage996697.name
  storage_container_name = azurerm_storage_container.devops-infra.name
  type                   = "Block"
  source                 = "some-local-file.zip"
} */

## Virtual Network



##Creating a windows vm

resource "azurerm_windows_virtual_machine" "devops-vm-demo1" {
  
  name = var.vm_name #"Devops-infra-vm"
  resource_group_name = azurerm_resource_group.devops.name
  location = azurerm_resource_group.devops.location
  size = var.vm_size
  admin_username = var.admin_username #"narendra"
  admin_password = "Narendra@19"
  vm_agent_platform_updates_enabled                      = true
  availability_set_id = azurerm_availability_set.devops.id
  network_interface_ids  = [
    azurerm_network_interface.devops-infra.id,
    

  ] 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-Datacenter"
    version   = "latest"
  }

}

##Data disks creation

resource "azurerm_managed_disk" "devops-datadisk" {

    name = "Devops-data-disks"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location
    storage_account_type = "Standard_LRS"
    disk_size_gb = "50"
     create_option        = "Empty"
  
}

## Attach data disks to the virtual machine

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  virtual_machine_id = azurerm_windows_virtual_machine.devops-vm-demo1.id
  managed_disk_id = azurerm_managed_disk.devops-datadisk.id
  lun = "10"
  caching = "ReadWrite"
}

##Linux virtual machine
/*
resource "azurerm_linux_virtual_machine" "linux-dev" {

    name = "Devops-linux"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location
    size = var.vm_size
    admin_username = var.admin_username #"narendra"
    admin_password = "Narendra@19"
    disable_password_authentication = false
    network_interface_ids = [azurerm_network_interface.devops-infratwo.id,
    ]
    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
     source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
*/

##Azure Bastion

resource "azurerm_bastion_host" "bastion" {

    name = "Dev-Bastion"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location

    ip_configuration {
      
      name = "internal"
      subnet_id = azurerm_subnet.bastion-host.id
      public_ip_address_id = azurerm_public_ip.bastion.id
    }
  
}


  