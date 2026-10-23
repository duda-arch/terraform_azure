output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "function_app_hostname" {
  value = azurerm_linux_function_app.function_app.default_hostname
}
