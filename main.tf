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
## Container
resource "azurerm_storage_container" "devops-infra" {
  name                  = "devops-infra"
  storage_account_name    = azurerm_storage_account.devopsstorage996697.name
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

resource "azurerm_windows_virtual_machine" "devops-vm-demo" {
  
  name = "Devops-infra-vm"
  resource_group_name = azurerm_resource_group.devops.name
  location = "UK West"
  size = "Standard_B2ats_v2"
  admin_username = "narendra"
  admin_password = "Narendra@19"
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
    sku       = "2022-Datacenter"
    version   = "latest"
  }

}