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

# PENDIENTE (paso 4): HSTS (setting_id = "security_header").
#
# HSTS le ordena al navegador "para este dominio, no vuelvas a intentar HTTP
# nunca más durante N segundos". Es muy eficaz y a la vez difícil de revertir:
# hasta que expire el max_age, los navegadores que ya lo recibieron se negarán
# a conectar por HTTP aunque tú desactives el ajuste. Por eso se activa DESPUÉS
# de comprobar que el HTTPS funciona de forma estable, y nunca antes.
