
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  required_version = ">=1.0.0"
}

provider "azurerm" {
  subscription_id = "684953b1-f4e8-440d-a185-2dbeb0988d95"
  tenant_id       = "4cef188b-ff7a-4a95-9399-53564a448d3e"
  features {}
}

resource "azurerm_resource_group" "web_rg" {
  name     = "WebServiceRG"
  location = "Central India"
}

resource "azurerm_service_plan" "Web_plan" {
  name                = "webPlan01"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  os_type             = "Windows"

  sku_name = "B1"

}
resource "azurerm_app_service" "web_app" {
  name                = "lg9723"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  app_service_plan_id = azurerm_service_plan.Web_plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  https_only = true
}
