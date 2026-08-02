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

variable "allowed_ssh_cidr" {
  type        = string
  description = "Origen permitido para SSH (22)."
  default     = "0.0.0.0/0"
}