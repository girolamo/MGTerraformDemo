output "storage_account_name" {
  value = azurerm_storage_account.demo_website_sa.name
}

output "front_door_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.demo_website_fd_endpoint.host_name}"
}
