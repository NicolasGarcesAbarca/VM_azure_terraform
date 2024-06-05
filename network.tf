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

resource "azurerm_network_security_group" "NSG1" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGNetwork.name
}

resource "azurerm_network_security_rule" "FIXED_IP_RDP" {
  name                        = "allowRDPFORIP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.ip_my_home
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RGNetwork.name
  network_security_group_name = azurerm_network_security_group.NSG1.name
}

resource "azurerm_network_security_rule" "FIXED_IP_SSH" {
  name                        = "allowSSHIP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RGNetwork.name
  network_security_group_name = azurerm_network_security_group.NSG1.name
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}

resource "azurerm_resource_group" "RGJump" {
  name     = "JumpApp"
  location = var.location
  tags = {
    evironment = "dev"
  }
}

resource "azurerm_storage_account" "JumpStorageDiagnostic" {
  name                = "jumpstordiag33"
  resource_group_name = azurerm_resource_group.RGJump.name

  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_public_ip" "nicjumppublicip" {
  name                = "JUMPIPPublic"
  resource_group_name = azurerm_resource_group.RGJump.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

