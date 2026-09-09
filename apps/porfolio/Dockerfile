# ============================================================================
#  Imagen del portfolio: nginx sirviendo ficheros estáticos.
#
#  BASE: nginxinc/nginx-unprivileged, no la imagen oficial de nginx.
#  La oficial arranca su proceso maestro como root para poder abrir el puerto
#  80, que es privilegiado. Esta variante escucha en el 8080 y corre como UID
#  101 desde el primer instante, lo que permite el runAsNonRoot del Deployment.
#
#  RAMA 1.30 = estable. nginx usa versiones menores PARES para la rama estable
#  (solo correcciones) e IMPARES para mainline (funcionalidades nuevas). Para
#  servir ficheros estáticos no hace falta nada nuevo: interesa lo aburrido.
#
#  FIJADA POR DIGEST, no por etiqueta. Una etiqueta como "1.30-alpine" es un
#  puntero móvil: el contenido detrás de ella cambia con cada parche. El digest
#  es el hash del contenido, así que la construcción es REPRODUCIBLE: hoy y
#  dentro de un año se obtiene exactamente la misma imagen base.
#
#  La etiqueta se conserva junto al digest solo para que un humano sepa qué
#  versión es. Docker ignora la etiqueta y usa el digest.
#
#  IMPORTANTE: fijar por digest sin más congelaría la imagen para siempre, lo
#  cual es lo contrario de seguro. Quien mantiene esto al día es Dependabot,
#  configurado en .github/dependabot.yml: abre un pull request cuando aparece
#  un digest nuevo. Reproducibilidad y actualización no están en conflicto,
#  pero hacen falta las dos piezas.
# ============================================================================
FROM nginxinc/nginx-unprivileged:1.30-alpine@sha256:9b87ad3dd9f431c733f19dfb278c7eb3dba9dca381942c79818bb42f1a566a83

# Etiquetas estándar OCI. Sirven para que, dado un contenedor en ejecución, se
# pueda averiguar de qué repositorio y de qué commit salió.
LABEL org.opencontainers.image.title="Portfolio de Gonzalo Pascual" \
      org.opencontainers.image.description="Web estática servida con nginx sin privilegios" \
      org.opencontainers.image.source="https://github.com/Gonzalo-Pascual/gonzalopascualweb"

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/
COPY css/       /usr/share/nginx/html/css/
COPY js/        /usr/share/nginx/html/js/
COPY imagenes/  /usr/share/nginx/html/imagenes/
COPY vendor/    /usr/share/nginx/html/vendor/
COPY CV_Gonzalo_Pascual_Romero_2024.pdf /usr/share/nginx/html/

# El puerto es informativo: no publica nada por sí mismo, pero documenta en
# qué puerto escucha el proceso. El Deployment lo declara en containerPort.
EXPOSE 8080
