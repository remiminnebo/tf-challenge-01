# Configure the Azure provider
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  # yeah buddy
  version         = "~>2.0"
  subscription_id = "${var.sub}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  features {}
}

resource "azurerm_resource_group" "slotApp1" {
  name     = "rg-rmi-tf-challenge-01"
  location = "westeurope"
}

resource "azurerm_app_service_plan" "slotApp1" {
  name                = "asp-rmi-tf-challenge-01"
  location            = azurerm_resource_group.slotApp1.location
  resource_group_name = azurerm_resource_group.slotApp1.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "slotApp1" {
  name                = "apps-rmi-tf-challenge-01"
  location            = azurerm_resource_group.slotApp1.location
  resource_group_name = azurerm_resource_group.slotApp1.name
  app_service_plan_id = azurerm_app_service_plan.slotApp1.id
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2",
    "ApiUrl"                       = "",
    "ApiUrlShoppingCart"           = "",
    "MongoConnectionString"        = "",
    "SqlConnectionString"          = "",
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail",
    "Personalizer__ApiKey"         = "",
    "Personalizer__Endpoint"       = ""
  }
}

resource "azurerm_app_service_slot" "slotApp1" {
  name                = "apps-s-rmi-tf-challenge-01"
  location            = azurerm_resource_group.slotApp1.location
  resource_group_name = azurerm_resource_group.slotApp1.name
  app_service_plan_id = azurerm_app_service_plan.slotApp1.id
  app_service_name    = azurerm_app_service.slotApp1.name
}
