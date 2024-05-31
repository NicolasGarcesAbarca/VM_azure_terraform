terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RGNetwork" {
  name     = "example-resources"
  location = "East Us"
  tags = {
    evironment = "dev"
  }
}

resource "azurerm_virtual_network" "virtualNetwork" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.RGNetwork.name
  location            = azurerm_resource_group.RGNetwork.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}


