resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "demo_website_rg" {
  name     = "MGTerraformDemoWebsiteRG"
  location = "West Europe"
}

resource "azurerm_storage_account" "demo_website_sa" {
  name                       = "mgdemowebsitesa${random_string.resource_code.result}"
  resource_group_name        = azurerm_resource_group.demo_website_rg.name
  location                   = azurerm_resource_group.demo_website_rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true
  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
}

resource "azurerm_storage_container" "demo_website_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.demo_website_sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "index_website" {
  name                   = "demo-index.html"
  storage_account_name   = azurerm_storage_account.demo_website_sa.name
  storage_container_name = azurerm_storage_container.demo_website_container.name
  type                   = "Block"
}

resource "azurerm_cdn_frontdoor_profile" "demo_website_fd" {
  name                = "MGTerraformDemoWebsiteFD"
  resource_group_name = azurerm_resource_group.demo_website_rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "demo_website_fd_endpoint" {
  name                     = "websitefdendpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.demo_website_fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "demo_website_fd_origin_group" {
  name                     = "demo-website-fd-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.demo_website_fd.id

  health_probe {
    interval_in_seconds = 240
    path                = "/index.html"
    protocol            = "Http"
    request_type        = "GET"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "demo_website_fd_origin" {
  name                           = "demo-website-fd-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.demo_website_fd_origin_group.id
  host_name                      = azurerm_storage_account.demo_website_sa.primary_web_host
  origin_host_header             = azurerm_storage_account.demo_website_sa.primary_web_host
  enabled                        = true
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "demo_website_fd_route" {
  name                          = "demo-website-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.demo_website_fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.demo_website_fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.demo_website_fd_origin.id]
  link_to_default_domain        = true
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
}