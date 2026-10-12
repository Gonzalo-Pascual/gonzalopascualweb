variable "hcloud_token" {
  type        = string
  description = "Token API de Hetzner Cloud (Read & Write)."
  sensitive   = true
}

variable "server_type" {
  type        = string
  description = "Tipo/plan del servidor Hetzner."
  default     = "cx23"
}

variable "location" {
  type        = string
  description = "Ubicación del datacenter (nbg1 = Núremberg)."
  default     = "nbg1"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Ruta a tu clave SSH pública."
  default     = "~/.ssh/oci_portfolio.pub"
}

# Interruptor de emergencia. En condiciones normales el puerto 22 NO existe
# para Internet: la administración va por Tailscale. Sólo si Tailscale fallara
# se pone a true, se aplica, se arregla el problema y se vuelve a false.
variable "ssh_emergencia" {
  type        = bool
  description = "Reabre SSH e ICMP desde allowed_ssh_cidr. Sólo si Tailscale no funciona."
  default     = false
}

# Sólo se usa con ssh_emergencia = true. Sin valor por defecto útil a
# propósito: en una emergencia hay que escribir la IP de ESE momento, porque la
# doméstica cambia a menudo y una guardada de hace semanas no serviría.
variable "allowed_ssh_cidr" {
  type        = string
  description = "IP pública de administración con máscara /32 (ej. 88.12.34.56/32). Sólo para la emergencia."
  default     = null

  validation {
    condition     = var.allowed_ssh_cidr == null || can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Debe ser un CIDR válido, con la máscara incluida. Ejemplo: 88.12.34.56/32"
  }

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "0.0.0.0/0 expondría SSH a todo Internet. Indica tu IP concreta con /32."
  }
}