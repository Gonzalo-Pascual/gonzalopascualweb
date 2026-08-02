# ============================================================================
#  Ajustes de seguridad de la zona
#
#  Todo esto se podría clicar en el panel de Cloudflare. Se define como código
#  por tres motivos: queda revisable en un 'plan', queda auditable en el
#  historial de git, y si alguien lo cambia a mano el siguiente 'apply' lo
#  detecta y lo revierte. Un ajuste de seguridad que nadie vigila es un ajuste
#  de seguridad que acabará desactivado.
# ============================================================================

# Cifrado entre Cloudflare y el origen. Ver la explicación de cada modo en
# variables.tf. Objetivo final: "strict".
resource "cloudflare_zone_setting" "ssl" {
  zone_id    = var.zone_id
  setting_id = "ssl"
  value      = var.cloudflare_ssl_mode
}

# Versión mínima de TLS aceptada a los VISITANTES. TLS 1.0 y 1.1 están
# obsoletos desde 2021 (RFC 8996) y arrastran cifrados rotos. Dejarlos
# habilitados es lo primero que marca en rojo cualquier escáner tipo SSL Labs.
resource "cloudflare_zone_setting" "min_tls_version" {
  zone_id    = var.zone_id
  setting_id = "min_tls_version"
  value      = "1.2"
}

# TLS 1.3: handshake más corto y elimina por diseño familias enteras de
# vulnerabilidades de versiones anteriores (RSA estático, renegociación,
# cifrados CBC).
resource "cloudflare_zone_setting" "tls_1_3" {
  zone_id    = var.zone_id
  setting_id = "tls_1_3"
  value      = "on"
}

# Redirige en el borde cualquier petición HTTP a HTTPS. Sin esto, la primera
# petición de un visitante que teclea el dominio sin protocolo viaja en claro.
resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.zone_id
  setting_id = "always_use_https"
  value      = "on"
}

# Reescribe a https:// los recursos que se pidan por http:// dentro de la
# página. Red de seguridad contra el contenido mixto.
resource "cloudflare_zone_setting" "automatic_https_rewrites" {
  zone_id    = var.zone_id
  setting_id = "automatic_https_rewrites"
  value      = "on"
}

# HSTS (HTTP Strict Transport Security).
#
# Le ordena al navegador: "para este dominio, durante los próximos max_age
# segundos, no intentes HTTP ni una sola vez; usa HTTPS directamente".
#
# Qué ataque evita, que no evita ya el redirect 301 de always_use_https: el
# redirect llega DEMASIADO TARDE. La primera petición del visitante que teclea
# "gonzalopascual.es" viaja en claro, y un atacante en la misma red (wifi de
# cafetería, por ejemplo) puede interceptarla y quedarse en medio antes de que
# el redirect ocurra. Es el ataque de "SSL stripping". Con HSTS, el navegador
# ni siquiera manda esa primera petición insegura.
#
# Es potente y difícil de revertir: hasta que expire el max_age, los
# navegadores que ya recibieron la cabecera se negarán a conectar por HTTP
# aunque desactives el ajuste. Por eso se activa DESPUÉS de comprobar que el
# HTTPS funciona de forma estable, nunca antes.
resource "cloudflare_zone_setting" "hsts" {
  zone_id    = var.zone_id
  setting_id = "security_header"

  value = {
    strict_transport_security = {
      enabled = true

      # Un año, el valor recomendado por OWASP para un dominio ya estable.
      max_age = 31536000

      # DESACTIVADO a propósito. Aplicaría HSTS también a todos los subdominios
      # (autodiscover, _dmarc...), que hoy son CNAMEs hacia IONOS y no controlo.
      # Si alguno sirviese algo por HTTP, quedaría inaccesible durante un año
      # sin poder revertirlo. Se activará cuando todos los subdominios sean míos.
      include_subdomains = false

      # DESACTIVADO a propósito. La lista de precarga va compilada DENTRO de los
      # navegadores: salir de ella tarda meses en llegar a los usuarios. Es un
      # billete casi de ida.
      preload = false

      # X-Content-Type-Options: nosniff. nginx ya la envía; esto la garantiza
      # también en el borde por si el origen cambiase de configuración.
      nosniff = true
    }
  }
}
