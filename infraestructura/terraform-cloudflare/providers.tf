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

    # Solo para leer las SALIDAS del workspace de Hetzner (ver dns.tf).
    # Fijado al parche y no a la menor: el provider sigue en 0.x, y en
    # versionado semántico eso significa que cada menor puede romper.
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.82.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Sin token explícito, a propósito: lo toma del fichero de credenciales que
# escribe 'terraform login' (~/.terraform.d/credentials.tfrc.json). No hay
# ningún secreto nuevo que guardar en el repositorio ni en el .tfvars.
provider "tfe" {}
