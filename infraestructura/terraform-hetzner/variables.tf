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

# A propósito SIN valor por defecto: obligar a declararlo explícitamente evita
# que un despiste deje el puerto 22 abierto a Internet. Si falta, Terraform lo
# pide por consola en vez de asumir nada.
variable "allowed_ssh_cidr" {
  type        = string
  description = "Única red autorizada a abrir SSH e ICMP. Tu IP pública con máscara /32 (ej. 88.12.34.56/32)."

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Debe ser un CIDR válido, con la máscara incluida. Ejemplo: 88.12.34.56/32"
  }

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "0.0.0.0/0 expondría SSH a todo Internet. Indica tu IP concreta con /32."
  }
}