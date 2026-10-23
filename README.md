# Terraform na Azure

Estudo prático de infraestrutura como código: uma rede na Azure em topologia **hub-and-spoke**, em que todo o tráfego das VMs passa por um **Azure Firewall** central. O projeto é dividido em módulos reutilizáveis do Terraform.

## Arquitetura

```
                 Internet
                    │
            ┌───────┴────────┐
            │ Azure Firewall │   VNet hub 10.0.0.0/16
            │  (IP público)  │   regras de rede (ICMP) e de aplicação (HTTPS)
            └───┬────────┬───┘
       peering  │        │  peering
      ┌─────────┴──┐  ┌──┴─────────┐
      │ VNet VM A  │  │ VNet VM B  │   ...uma VNet por VM (10.1.0.0/16, 10.2.0.0/16)
      │ Ubuntu VM  │  │ Ubuntu VM  │   rotas apontando para o firewall
      └────────────┘  └────────────┘

      Storage Account + App Service Plan + Function App (Linux)
      integrados à VNet
```

## Módulos

| Módulo | O que cria |
|---|---|
| `az_firewall` | VNet hub, subnet do firewall, IP público, Azure Firewall e coleções de regras de rede e de aplicação |
| `az_networking` | Uma VNet e uma subnet por VM, interfaces de rede e Network Security Groups |
| `az_perring` | Peering nos dois sentidos entre cada VNet e o hub, e tabela de rotas que envia o tráfego para o firewall |
| `az_vm` | VMs Linux (Ubuntu) com chave SSH gerada pelo Terraform |
| `az_storage_asp` | Storage Account, container de blobs, App Service Plan e Function App Linux integrada à VNet |

Os ambientes são declarados num mapa em `variables.tf`. Cada item vira uma VM (`with_vm = true`) ou uma Function App integrada à rede (`with_vm = false`).

## Como usar

Pré-requisitos: [Terraform](https://developer.hashicorp.com/terraform/install) e [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) com login feito (`az login`).

```bash
cd teleginsk_project
cp terraform.tfvars.example terraform.tfvars   # preencha assinatura, tenant e senha das VMs
terraform init
terraform plan
terraform apply
```

Para apagar tudo depois: `terraform destroy`.

> O `terraform.tfvars` guarda dados da sua conta e está no `.gitignore`. Nunca envie esse arquivo para o repositório.

## Tecnologias

Terraform · Azure (VNet, Peering, Azure Firewall, Route Table, NSG, Linux VM, Storage Account, App Service Plan, Function App)
