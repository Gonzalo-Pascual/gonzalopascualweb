variable "region" {
    type        = string
    description = "Spain Madrid"
    default     = "eu-madrid-1"
}

variable "tenancy_ocid" {
    type        = string
    description = "OCI Tenancy OCID"
}

variable "vcn_cidr" {
  type        = string
  description = "Rango de la red virtual."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "Rango de la subred pública."
  default     = "10.0.1.0/24"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Origen permitido para SSH"
  default     = "0.0.0.0/0"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Ruta a tu clave SSH pública para la VM."
  default     = "~/.ssh/oci_portfolio.pub"
}

variable "instance_ocpus" {
  type        = number
  description = "OCPUs (hasta 4 en ARM A1)."
  default     = 2
}

variable "instance_memory_gbs" {
  type        = number
  description = "Memoria en GB (hasta 24 en ARM A1)."
  default     = 12
}