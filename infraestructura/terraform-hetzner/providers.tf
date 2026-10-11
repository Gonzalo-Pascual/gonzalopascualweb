terraform {
  required_version = ">= 1.5.0"

  # ==========================================================================
  #  Estado remoto en HCP Terraform
  #
  #  Hasta octubre de 2026 el estado vivía SOLO en el disco del portátil: si se
  #  estropeaba, la infraestructura seguía funcionando pero se perdía la
  #  capacidad de gestionarla con Terraform. Era el punto único de fallo más
  #  silencioso del proyecto.
  #
  #  El espacio de trabajo está configurado en MODO DE EJECUCIÓN LOCAL (ajuste
  #  del workspace en la web, no de este bloque):
  #
  #   · HCP guarda el estado, lo bloquea durante cada operación y conserva un
  #     historial de versiones para poder volver atrás si se corrompe.
  #   · Los 'plan' y 'apply' siguen corriendo en esta máquina y leen el
  #     terraform.tfvars local. EL TOKEN DE HETZNER NO SALE NUNCA DE AQUÍ: HCP
  #     recibe el resultado, no las credenciales.
  #
  #  Con ejecución remota habría que subir el token a HCP, y además fallaría la
  #  lectura de la clave pública SSH de ~/.ssh, que solo existe en el WSL.
  # ==========================================================================
  cloud {
    organization = "gonzalopascual"

    workspaces {
      name = "portfolio-hetzner"
    }
  }

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