terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.56.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}
