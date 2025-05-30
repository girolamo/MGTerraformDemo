terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}