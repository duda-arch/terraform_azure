variable "resource_group_name" {
  type        = string
  description = "Nome do resource group."
}

variable "resource_group_location" {
  type        = string
  description = "Região do resource group."
}

variable "function_subnet_id" {
  type        = string
  description = "Subnet delegada onde a Function App se conecta à rede."
}

variable "function_source_dir" {
  type        = string
  description = "Pasta com o código da Function App, que vira o pacote .zip."
}
