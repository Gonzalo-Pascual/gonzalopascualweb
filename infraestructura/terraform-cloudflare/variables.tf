variable "cloudflare_api_token" {
  type        = string
  description = "Token de API de Cloudflare, acotado a la zona gonzalopascual.es (Zone:Read, DNS:Edit, Zone Settings:Edit)."
  sensitive   = true
}

# El ID de zona NO es un secreto: es un identificador público que aparece en el
# propio panel de Cloudflare. Se deja con valor por defecto para no tener que
# repetirlo en cada ejecución.
variable "zone_id" {
  type        = string
  description = "ID de la zona de Cloudflare para gonzalopascual.es."
  default     = "022df2a7487df6ebb1ec30994f490630"
}

variable "domain" {
  type        = string
  description = "Dominio raíz gestionado en esta zona."
  default     = "gonzalopascual.es"
}

# Modo de cifrado entre Cloudflare y el origen:
#
#   off      → sin TLS. Nunca.
#   flexible → Cloudflare habla HTTP con el origen. El candado del navegador
#              MIENTE: el último tramo va en claro. Nunca.
#   full     → TLS hasta el origen, pero acepta certificados autofirmados.
#              Cifra, pero NO protege de un ataque de intermediario, porque no
#              comprueba con quién está hablando.
#   strict   → TLS hasta el origen y el certificado debe ser válido y estar
#              emitido por una CA de confianza. El único modo correcto.
#
# Arranca en "full" a propósito: Traefik todavía sirve su certificado
# autofirmado de fábrica y "strict" tumbaría la web. Se cambia a "strict" en
# cuanto cert-manager emita el certificado de Let's Encrypt (paso 4).
variable "cloudflare_ssl_mode" {
  type        = string
  description = "Modo SSL/TLS de la zona: off, flexible, full o strict."
  default     = "full"

  validation {
    condition     = contains(["full", "strict"], var.cloudflare_ssl_mode)
    error_message = "Solo se permiten 'full' (temporal) y 'strict' (objetivo). 'off' y 'flexible' dejan tráfico sin cifrar."
  }
}
