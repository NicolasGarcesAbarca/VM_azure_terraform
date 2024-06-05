resource "azurerm_resource_group" "RGNetwork" {
  name     = "NetworkGroup"
  location = var.location
  tags = {
    evironment = "dev"
  }
}

resource "azurerm_virtual_network" "virtualNetwork" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.RGNetwork.name
  location            = var.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}


resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.RGNetwork.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = ["10.123.0.0/24"]
}

resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.RGNetwork.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "NSG1" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGNetwork.name
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}

