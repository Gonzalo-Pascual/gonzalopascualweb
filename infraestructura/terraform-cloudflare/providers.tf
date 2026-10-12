terraform {
  required_version = ">= 1.5.0"

  # Estado remoto en HCP Terraform, en modo de ejecución LOCAL. Ver la
  # explicación completa en terraform-hetzner/providers.tf: HCP guarda y
  # versiona el estado, pero el token de Cloudflare nunca sale de esta máquina.
  cloud {
    organization = "gonzalopascual"

    workspaces {
      name = "portfolio-cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # La v5 reescribió el provider por completo: 'cloudflare_record' pasó a
      # llamarse 'cloudflare_dns_record' y cambió el esquema. Fijamos la major
      # para que un 'init -upgrade' no rompa la configuración sin avisar.
      version = "~> 5.0"
    }

    # El provider 'tfe' (que leía la IP del stack de Hetzner) se retiró el
    # 2026-10-12 junto con el registro A: la web ya no tiene servidor propio.
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
