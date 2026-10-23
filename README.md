# Terraform na Azure

[![Terraform](https://github.com/duda-arch/terraform_azure/actions/workflows/terraform.yml/badge.svg)](https://github.com/duda-arch/terraform_azure/actions/workflows/terraform.yml)

Estudo prático de infraestrutura como código: uma rede na Azure em topologia **hub-and-spoke**, em que todo o tráfego que sai das VMs e da Function App passa por um **Azure Firewall** central. O projeto é dividido em módulos reutilizáveis do Terraform.

## Arquitetura

```
                       Internet
                          │
                  ┌───────┴────────┐
                  │ Azure Firewall │   VNet hub 10.0.0.0/16
                  │  (IP público)  │   regras: ICMP entre as VMs e HTTPS de saída
                  └──┬─────┬────┬──┘
           peering   │     │    │   peering
       ┌─────────────┘     │    └──────────────┐
┌──────┴──────┐   ┌────────┴────┐   ┌──────────┴─────────┐
│  VNet A     │   │  VNet B     │   │  VNet C            │
│  Ubuntu VM  │   │  Ubuntu VM  │   │  Function App      │
│ 10.1.0.0/16 │   │ 10.2.0.0/16 │   │  (integração VNet) │
└─────────────┘   └─────────────┘   │  10.3.0.0/16       │
                                    └────────────────────┘
   Cada subnet tem uma rota 0.0.0.0/0 apontando para o firewall.
```

## Módulos

| Módulo | O que cria |
|---|---|
| `az_firewall` | VNet hub, subnet do firewall, IP público, Azure Firewall e coleções de regras de rede (ICMP) e de aplicação (HTTPS) |
| `az_networking` | Uma VNet e uma subnet por ambiente, interfaces de rede e Network Security Group das VMs. A subnet da Function App é delegada ao App Service |
| `az_perring` | Peering nos dois sentidos entre cada VNet e o hub, e rota padrão de cada subnet passando pelo firewall |
| `az_vm` | VMs Ubuntu 22.04 com chave SSH gerada pelo Terraform |
| `az_storage_asp` | Storage Account, App Service Plan B1 e Function App Python 3.11 integrada à VNet, publicada a partir de um pacote .zip com link de acesso temporário (SAS) |

Os ambientes são declarados num mapa em `teleginsk_project/variables.tf`. Cada item vira uma VM (`with_vm = true`) ou a rede da Function App (`with_vm = false`).

## Como usar

Pré-requisitos: [Terraform](https://developer.hashicorp.com/terraform/install) 1.3 ou superior e [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) com login feito (`az login`).

```bash
cd teleginsk_project
cp terraform.tfvars.example terraform.tfvars   # preencha assinatura e tenant
terraform init
terraform plan
terraform apply
```

Depois de criar:

```bash
terraform output firewall_public_ip
terraform output function_app_hostname
terraform output -json vm_private_keys    # chaves SSH das VMs
```

Para apagar tudo: `terraform destroy`.

> **Custos**: o Azure Firewall é cobrado por hora e é o item mais caro deste estudo. Rode `terraform destroy` assim que terminar os testes.
>
> O `terraform.tfvars` guarda dados da sua conta e está no `.gitignore`. Nunca envie esse arquivo para o repositório.

## Validação automática

A cada push, o GitHub Actions roda `terraform fmt -check`, `terraform init` e `terraform validate`.

## Tecnologias

Terraform · Azure (VNet, Peering, Azure Firewall, Route Table, NSG, Linux VM, Storage Account, App Service Plan, Function App) · GitHub Actions
