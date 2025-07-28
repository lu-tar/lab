# Check credentials.auto.tfvars
# https://developer.hashicorp.com/terraform/language/values/variables
# https://github.com/Telmate/terraform-provider-proxmox
# To set lots of variables, it is more convenient to specify their values in a variable definitions file 
# (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file
# Terraform also automatically loads a number of variable definitions files if they are present:
#    Files named exactly terraform.tfvars or terraform.tfvars.json.
#    Any files with names ending in .auto.tfvars or .auto.tfvars.json.
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

variable "PROXMOX_URL" {
  type = string
}

variable "PROXMOX_USER" {
  type      = string
  sensitive = true
}

variable "PROXMOX_TOKEN" {
  type      = string
  sensitive = true
}

variable "PUBLIC_SSH_KEY" {
  type      = string
  sensitive = true
}

variable "CI_PASSWORD" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  pm_api_url = var.PROXMOX_URL
  pm_api_token_id = var.PROXMOX_USER
  pm_api_token_secret = var.PROXMOX_TOKEN
  pm_tls_insecure = true
}
