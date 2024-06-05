resource "azurerm_bastion_host" "bastionHost" {
  name                = "bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGJump.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
}

resource "azurerm_public_ip" "bastion-pip" {
  name                = "IPPublicBastion"
  resource_group_name = azurerm_resource_group.RGJump.name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
}