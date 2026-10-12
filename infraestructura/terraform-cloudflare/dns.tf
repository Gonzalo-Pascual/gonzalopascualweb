# ============================================================================
#  Registros DNS de gonzalopascual.es
#
#  TRÁFICO WEB: ya NO está aquí. Desde el 2026-10-12 la web se sirve desde
#  Cloudflare Workers (ver wrangler.jsonc en la raíz). Los dominios
#  gonzalopascual.es y www.gonzalopascual.es se conectan al Worker como
#  "Custom Domains" desde su panel, y es Cloudflare quien crea y gestiona esos
#  registros; si Terraform también los declarase, los dos se pelearían por el
#  mismo nombre. Antes había aquí un registro A hacia la VM de Hetzner (leído
#  del otro stack con tfe_outputs) y un CNAME para www.
#
#  CORREO E INFRAESTRUCTURA (MX, TXT, _dmarc, autodiscover) → proxied = false.
#  Proxear estos registros los ROMPE: Cloudflare solo sabe hacer de proxy para
#  HTTP/HTTPS, y al proxear un CNAME deja de devolver el destino real y contesta
#  con sus propias IPs. Un servidor de correo que busque la política DMARC no
#  encuentra nada.
# ============================================================================

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
