# ============================================================================
#  Cortafuegos perimetral de Hetzner Cloud
#
#  Se aplica FUERA de la máquina (en la red de Hetzner), así que el tráfico
#  bloqueado ni siquiera llega al sistema operativo. Es una capa distinta e
#  independiente de nftables/ufw dentro de la VM: defensa en profundidad.
#
#  Filosofía: denegar por defecto. Hetzner sólo evalúa reglas de tipo "permitir";
#  todo lo que no encaje con ninguna regla de entrada, se descarta. No hace falta
#  (ni existe) una regla final de DROP.
#
#  El tráfico de SALIDA se deja libre a propósito: la VM necesita alcanzar
#  Let's Encrypt (ACME), la API de Cloudflare (reto DNS-01), ghcr.io (imágenes)
#  y los repositorios de Ubuntu (actualizaciones automáticas de seguridad).
# ============================================================================

# --- Rangos de red de Cloudflare -------------------------------------------
#
#  En lugar de copiar y pegar una lista de CIDRs que quedará obsoleta, la
#  descargamos de la fuente oficial en cada 'plan'. Cloudflare publica sus
#  rangos en dos ficheros de texto plano, una red por línea.
#
#  Ventaja: si Cloudflare añade un rango nuevo, el siguiente 'terraform apply'
#  lo incorpora solo. Inconveniente: si estas URLs no responden, el 'plan' falla
#  (fallo seguro: preferimos no aplicar a aplicar una lista incompleta que
#  dejaría la web caída para parte de los visitantes).

data "http" "cloudflare_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "http" "cloudflare_ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}

locals {
  # trimspace() por cada línea y compact() para descartar las vacías: así da
  # igual que el fichero termine en salto de línea o venga con retornos de carro.
  cloudflare_ips = compact([
    for cidr in concat(
      split("\n", data.http.cloudflare_ipv4.response_body),
      split("\n", data.http.cloudflare_ipv6.response_body),
    ) : trimspace(cidr)
  ])
}

resource "hcloud_firewall" "web" {
  name = "fw-portfolio"

  # --- Administración -------------------------------------------------------

  rule {
    description = "SSH solo desde la IP de administracion"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = [var.allowed_ssh_cidr]
  }

  rule {
    description = "ICMP solo desde la IP de administracion (diagnostico)"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = [var.allowed_ssh_cidr]
  }

  # --- Tráfico web: únicamente a través de Cloudflare -----------------------
  #
  #  Impide el "origin bypass": que alguien descubra la IP del servidor (via
  #  Shodan, Censys o histórico de DNS) y ataque directamente saltándose el
  #  WAF, el rate limiting y la mitigación DDoS de Cloudflare.

  rule {
    description = "HTTP solo desde la red de Cloudflare"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = local.cloudflare_ips
  }

  rule {
    description = "HTTPS solo desde la red de Cloudflare"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = local.cloudflare_ips
  }
}

# --- Salidas de verificación ------------------------------------------------

output "cloudflare_ranges_count" {
  description = "Cuántos rangos de Cloudflare se han cargado (deberían ser ~22)."
  value       = length(local.cloudflare_ips)
}

output "ssh_allowed_from" {
  description = "Origen que podrá abrir SSH. Compruébalo ANTES de aplicar."
  value       = var.allowed_ssh_cidr
}
