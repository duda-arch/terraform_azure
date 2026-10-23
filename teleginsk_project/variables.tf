##                ##      
## BEGIN FIREWALL ##
##                ##
variable "icmp_rules" {
  default = [
    {
      name                  = "Allow-ICMP-SubnetA-to-SubnetB"
      protocols             = ["ICMP"]
      source_addresses      = ["10.1.0.0/24"]  # Origem: Subnet A
      destination_addresses = ["10.2.0.0/24"]  # Destino: Subnet B
      destination_ports     = ["*"]
    },
    {
      name                  = "Allow-ICMP-SubnetB-to-SubnetA"
      protocols             = ["ICMP"]
      source_addresses      = ["10.2.0.0/24"]  # Origem: Subnet B
      destination_addresses = ["10.1.0.0/24"]  # Destino: Subnet A
      destination_ports     = ["*"]
    }
  ]
}
variable "https_rules" {
  default = [
    {
      name             = "Allow-HTTPS-Rule1"
      source_addresses = ["10.2.0.0/24"]
      target_fqdns     = ["*"] 

      protocol = {
        type = "Https"
        port = 443
      }
    },
    {
      name             = "Allow-HTTPS-Rule2"
      source_addresses = ["10.3.0.0/24"]
      target_fqdns     = ["*"] 

      protocol  = {
        type = "Https"
        port = 443
      }
    },
   
  ]
}
##              ##      
## END FIREWALL ##
##              ##

##                  ##      
## BEGIN NETWORKING ##
##                  ##
variable "security_rule" {
  default = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-ICMP-Inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-All-Outbound"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

##                  ##      
## END NETWORKING   ##
##                  ##
resource "azurerm_management_group" "sandbox"{
  name = "sandbox"
  display_name = "Sandbox"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/Root"
}

locals {
  vms = {
    vm_a = {
      with_vm      = true
      suffix       = "a"
      name         = "ubuntu-vma"
      size         = "Standard_B1s"
      username     = "vma_user"
      admin_username = "vma_user"
      admin_password = var.vm_admin_password
      vnet_address_space          = ["10.1.0.0/16"]
      subnet_address_prefixes     = ["10.1.0.0/24"]
      nic_private_ip_address      = "10.1.0.10"
    },
    vm_b = {
      with_vm      = true
      suffix       = "b"
      name         = "ubuntu-vmb"
      size         = "Standard_B1s"
      username     = "vmb_user"
      admin_username = "vmb_user"
      admin_password = var.vm_admin_password
      vnet_address_space          = ["10.2.0.0/16"]
      subnet_address_prefixes     = ["10.2.0.0/24"]
      nic_private_ip_address      = "10.2.0.10"
    },
    vm_c = {
      with_vm      = false
      suffix       = "c"
      name         = "ubuntu-vmc"
      size         = "Standard_B1s"
      username     = "vmc_user"
      admin_username = "vmc_user"
      admin_password = var.vm_admin_password
      vnet_address_space          = ["10.3.0.0/16"]
      subnet_address_prefixes     = ["10.3.0.0/24"]
      nic_private_ip_address      = "10.3.0.10"    
    }
  }
}

variable "resource_group_name" {
  type        = string
  default     = "rg_storage_account_blobs_teleginsk"
  description = ""
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "subscription_id" {
  type        = string
  description = "ID da assinatura da Azure. Defina em terraform.tfvars."
}

variable "tenant_id" {
  type        = string
  description = "ID do tenant (Microsoft Entra ID). Defina em terraform.tfvars."
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "Senha do usuário administrador das VMs. Defina em terraform.tfvars."
}