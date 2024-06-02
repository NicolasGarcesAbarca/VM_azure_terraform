resource "azurerm_network_interface" "NicVmJump" {
  name                = "jumpVM-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.RGJump.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nicjumppublicip.id
  }
}

resource "azurerm_linux_virtual_machine" "JumpVM" {
  name                = "JumpApp-machine"
  resource_group_name = azurerm_resource_group.RGJump.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NicVmJump.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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