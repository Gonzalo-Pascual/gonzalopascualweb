terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # La v5 reescribió el provider por completo: 'cloudflare_record' pasó a
      # llamarse 'cloudflare_dns_record' y cambió el esquema. Fijamos la major
      # para que un 'init -upgrade' no rompa la configuración sin avisar.
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
