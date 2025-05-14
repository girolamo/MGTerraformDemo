resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate_rg" {
  name     = "MGTerraformDemoTfstateRG"
  location = "West Europe"
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                            = "tfstatesa${random_string.resource_code.result}"
  resource_group_name             = azurerm_resource_group.tfstate_rg.name
  location                        = azurerm_resource_group.tfstate_rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}

resource "local_file" "backend_config_dump" {
  filename = "backend.config"
  content  = <<EOT
resource_group_name = "${azurerm_resource_group.tfstate_rg.name}"
storage_account_name = "${azurerm_storage_account.tfstate_sa.name}"
container_name = "${azurerm_storage_container.tfstate_container.name}"
EOT
}