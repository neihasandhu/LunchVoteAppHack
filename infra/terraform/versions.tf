terraform {
  required_version = "1.11.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatelunchvote"
    container_name       = "tfstate"
    key                  = "lunchvote-dev.tfstate"
    use_azuread_auth     = true
  }
}
