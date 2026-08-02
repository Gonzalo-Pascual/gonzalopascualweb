# ============================================================================
#  Adopción de los registros que ya existían en Cloudflare
#
#  Los bloques 'import' (Terraform >= 1.5) son la forma declarativa de decirle
#  a Terraform "este recurso ya existe ahí fuera, hazte cargo de él" en vez de
#  crearlo. La alternativa antigua era el comando 'terraform import', que es
#  imperativo y no queda registrado en el repositorio.
#
#  Por qué importa aquí: sin esto, el primer 'apply' intentaría CREAR unos MX
#  que ya existen. La API devolvería un error de duplicado, o peor, en otros
#  proveedores se destruirían y recrearían, dejando el correo caído mientras
#  tanto.
#
#  El formato del id es '<zone_id>/<record_id>'. Ninguno de los dos es secreto:
#  son identificadores internos de Cloudflare, no credenciales.
#
#  Una vez completado el primer 'apply' con éxito, estos bloques ya no hacen
#  nada y este fichero se puede borrar. Se conserva de momento como parte de la
#  historia de la migración.
# ============================================================================

import {
  to = cloudflare_dns_record.apex
  id = "022df2a7487df6ebb1ec30994f490630/8ca284a4c322859ae7e0bebba33af0f4"
}

import {
  to = cloudflare_dns_record.mx00
  id = "022df2a7487df6ebb1ec30994f490630/c54d46323938185cbb1a59db235031f9"
}

import {
  to = cloudflare_dns_record.mx01
  id = "022df2a7487df6ebb1ec30994f490630/9300ce6a7dddf151563dd4067141a15a"
}

import {
  to = cloudflare_dns_record.spf
  id = "022df2a7487df6ebb1ec30994f490630/77f1250220df9d16f7cdffd79bc9670c"
}

import {
  to = cloudflare_dns_record.dmarc
  id = "022df2a7487df6ebb1ec30994f490630/83332139461f7a0856abd09755d169e3"
}

import {
  to = cloudflare_dns_record.autodiscover
  id = "022df2a7487df6ebb1ec30994f490630/36778706f0c97bdabf820dfc26eb4b1e"
}

import {
  to = cloudflare_dns_record.domainconnect
  id = "022df2a7487df6ebb1ec30994f490630/1eaa644a4f7c35a352bba13e9317a62c"
}

# NOTA: 'www' no lleva bloque import porque no existía. Terraform lo creará.
#
# NOTA: el registro AAAA del apex (id 4105130dd5d1c1d85fb96bc0666e7cd7,
# apuntando a 2001:8d8:100f:f000::200, de IONOS) tampoco se importa: se elimina
# antes de aplicar. El motivo está explicado en el runbook del paso 3.
