terraform {

    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {

    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstate996697"
    container_name       = "tfstate"
    key                  = "infra.tfstate"

  }

}