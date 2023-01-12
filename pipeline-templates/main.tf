terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

variable "env_name" {
  type = string
  default= "dev"
}

resource "azurerm_resource_group" "rg-dev" {
  name     = "rg-${var.env_name}"
  location = "westeurope"
}



resource "azurerm_app_service_plan" "app-service-dev" {
    name                = "app-service-${var.env_name}"
    location            = azurerm_resource_group.rg-dev.location
    resource_group_name = azurerm_resource_group.rg-dev.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}




resource "azurerm_app_service" "webapp-dev508050" {
    name                = "webapp-${var.env_name}508050"
    location            = azurerm_resource_group.rg-dev.location
    resource_group_name = azurerm_resource_group.rg-dev.name
    app_service_plan_id = azurerm_app_service_plan.app-service-dev.id
}




resource "azurerm_sql_server" "sql-server-dev508050" {
    name                         = "sql-server-${var.env_name}508050"
    resource_group_name          = "${azurerm_resource_group.rg-dev.name}"
    location                     = "${azurerm_resource_group.rg-dev.location}"
    version                      = "12.0"
    administrator_login          = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}





resource "azurerm_sql_database" "sql-database-dev508050" {
  name                             = "sql-database-${var.env_name}508050"
  resource_group_name              = "${azurerm_resource_group.rg-dev.name}"
  location                         = "${azurerm_resource_group.rg-dev.location}"
  server_name                      = "${azurerm_sql_server.sql-server-dev508050.name}"
  edition                          = "Standard"
  requested_service_objective_name = "S1"
}



