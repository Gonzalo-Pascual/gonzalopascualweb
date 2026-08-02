terraform {
  required_version = ">= 1.5.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }

    # Sólo para descargar la lista oficial de rangos de red de Cloudflare
    # en firewall.tf. No requiere credenciales.
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}