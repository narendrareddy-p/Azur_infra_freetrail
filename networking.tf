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
resource "azurerm_subnet" "bastion" {
    name = "bation-subnet"
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name = azurerm_resource_group.devops.name
    address_prefixes = ["10.0.1.48/27" ]
  
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

resource "azurerm_public_ip" "bastion" {
    name = "bastion-publicip"
    resource_group_name = azurerm_resource_group.devops.name
    location = azurerm_resource_group.devops.location
    allocation_method = "Static"
    sku = "Standard"
  
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