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

resource "azurerm_virtual_network" "vnet" {
    name = "devops-infra-vnet"
    location = azurerm_resource_group.devops.location
    resource_group_name = azurerm_resource_group.devops.name
    address_space = ["10.0.1.0/24"]
    tags = azurerm_resource_group.devops.tags
  
}
##subnet creation
resource "azurerm_subnet" "subnet" {
    name = "infra_devops_dev"
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.devops.name
    address_prefixes = [local.subnet_address_prefix[0]]
  
}

resource "azurerm_subnet" "devops" {
    for_each = var.app_subnets
    name = each.value.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.devops.name
    address_prefixes = each.value.address_prefixes
  
}

resource "azurerm_subnet" "subnet1" {
    name = "infra_devops_dev1"
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.devops.name
    address_prefixes = [local.subnet_address_prefix[1]]
  
}

##Network Interface

resource "azurerm_network_interface" "devops-infra" {

    name = "devops-infra-nic"
    location = azurerm_virtual_network.vnet.location
    resource_group_name = azurerm_resource_group.devops.name

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      #Associating public ip to the NIC
      public_ip_address_id = azurerm_public_ip.devops-demo.id
    }

    tags = azurerm_resource_group.devops.tags
  
}

resource "azurerm_network_interface" "infra-devops" {
    count = 2
    name = "webinterface0${count.index + 1}"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_virtual_network.vnet.location

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }
  
}

resource "azurerm_network_interface" "devops-infratwo" {
  name = "devops-infra-two"
  location = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

  ip_configuration {
    name = "internalone"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

  }
}
##Public ip address creation
resource "azurerm_public_ip" "devops-demo" {
    name = "Devops-public-ip"
    location = azurerm_resource_group.devops.location
    resource_group_name = azurerm_resource_group.devops.name
    allocation_method = "Static"
    sku = "Standard"

    tags = azurerm_resource_group.devops.tags
  
}

##Network security group

resource "azurerm_network_security_group" "devops-nsg" {

    name = "Devops-nsg"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location
    security_rule  {
        name                       = "Allow_RDP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "3389"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
    name                       = "Allow_HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
     }
    tags = azurerm_resource_group.devops.tags
  
}

##Associating the NSG to the subnet

resource "azurerm_subnet_network_security_group_association" "devops-infra" {
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.devops-nsg.id
  
}

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
    azurerm_network_interface.devops-infratwo.id,

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