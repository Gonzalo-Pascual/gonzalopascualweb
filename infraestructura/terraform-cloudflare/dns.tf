# ============================================================================
#  Registros DNS de gonzalopascual.es
#
#  Dos familias de registros con reglas opuestas:
#
#   · Tráfico WEB (A, CNAME www)  → proxied = true.
#     Cloudflare oculta la IP real, filtra con su WAF y absorbe DDoS.
#
#   · Correo e infraestructura (MX, TXT, _dmarc, autodiscover) → proxied = false.
#     Proxear estos registros los ROMPE: Cloudflare solo sabe hacer de proxy
#     para HTTP/HTTPS, y al proxear un CNAME deja de devolver el destino real y
#     contesta con sus propias IPs. Un servidor de correo que busque la política
#     DMARC no encuentra nada.
# ============================================================================

# La IP del origen se lee del estado del stack de Hetzner en lugar de copiarla
# a mano. Si la VM se recrea y cambia de IP, el DNS la sigue automáticamente.
data "terraform_remote_state" "hetzner" {
  backend = "local"

  config = {
    path = "../terraform-hetzner/terraform.tfstate"
  }
}

locals {
  origin_ipv4 = data.terraform_remote_state.hetzner.outputs.instance_public_ip
}

# --- Tráfico web -------------------------------------------------------------

resource "cloudflare_dns_record" "apex" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  content = local.origin_ipv4
  proxied = true
  ttl     = 1 # 1 = automático; obligatorio cuando proxied = true
  comment = "Origen: VM de Hetzner. Gestionado por Terraform."
}

# www como CNAME al apex en lugar de un segundo registro A: así solo existe una
# IP que mantener. Cloudflare aplana el CNAME en el apex automáticamente.
resource "cloudflare_dns_record" "www" {
  zone_id = var.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  content = var.domain
  proxied = true
  ttl     = 1
  comment = "Alias de cortesia. Redirige al apex por Redirect Rule."
}

# --- Correo (IONOS) ----------------------------------------------------------
#
#  Estos registros son de IONOS, no míos. Se incorporan a Terraform para que
#  queden documentados y protegidos: si alguien los borra desde el panel, el
#  siguiente 'plan' lo detecta y los restaura.

resource "cloudflare_dns_record" "mx00" {
  zone_id  = var.zone_id
  name     = var.domain
  type     = "MX"
  content  = "mx00.ionos.es"
  priority = 10
  proxied  = false
  ttl      = 1
  comment  = "Correo IONOS. No proxear."
}

resource "cloudflare_dns_record" "mx01" {
  zone_id  = var.zone_id
  name     = var.domain
  type     = "MX"
  content  = "mx01.ionos.es"
  priority = 10
  proxied  = false
  ttl      = 1
  comment  = "Correo IONOS. No proxear."
}

# SPF: declara qué servidores están autorizados a enviar correo en nombre del
# dominio. El "~all" final es softfail (marcar como sospechoso, no rechazar).
resource "cloudflare_dns_record" "spf" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  content = "\"v=spf1 include:_spf-eu.ionos.com ~all\""
  proxied = false
  ttl     = 1
  comment = "SPF de IONOS."
}

# --- Registros de IONOS que estaban mal configurados -------------------------
#
#  Los tres estaban con proxied = true. Se corrigen a false.

# DMARC: le dice al receptor qué hacer con un correo que falla SPF/DKIM. Al
# estar proxeado, la consulta TXT no devolvía nada y el dominio quedaba sin
# ninguna política antisuplantación.
resource "cloudflare_dns_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "CNAME"
  content = "dmarc.ionos.es"
  proxied = false
  ttl     = 1
  comment = "Politica DMARC gestionada por IONOS. NUNCA proxear."
}

# Autodescubrimiento de Outlook: el cliente consulta este nombre para encontrar
# el servidor de correo. Proxeado devolvía las IPs de Cloudflare.
resource "cloudflare_dns_record" "autodiscover" {
  zone_id = var.zone_id
  name    = "autodiscover.${var.domain}"
  type    = "CNAME"
  content = "adsredir.ionos.info"
  proxied = false
  ttl     = 1
  comment = "Autodiscover de Outlook (IONOS). No proxear."
}

resource "cloudflare_dns_record" "domainconnect" {
  zone_id = var.zone_id
  name    = "_domainconnect.${var.domain}"
  type    = "CNAME"
  content = "_domainconnect.ionos.com"
  proxied = false
  ttl     = 1
  comment = "Domain Connect de IONOS. No proxear."
}

# --- Salidas de verificación -------------------------------------------------

output "origin_ipv4" {
  description = "IP a la que apunta el registro A, leída del stack de Hetzner."
  value       = local.origin_ipv4
}
