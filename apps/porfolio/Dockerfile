# ============================================================================
#  Imagen del portfolio: nginx sirviendo ficheros estáticos.
#
#  BASE: nginxinc/nginx-unprivileged, no la imagen oficial de nginx.
#  La oficial arranca su proceso maestro como root para poder abrir el puerto
#  80, que es privilegiado. Esta variante escucha en el 8080 y corre como UID
#  101 desde el primer instante, lo que permite el runAsNonRoot del Deployment.
#
#  RAMA 1.31 = mainline. nginx usa versiones menores PARES para la rama estable
#  (solo correcciones retroportadas) e IMPARES para mainline. Se elige mainline
#  por dos motivos:
#
#   1. SEGURIDAD: mainline recibe las correcciones primero; la rama estable las
#      recibe después, retroportadas. Elegir deliberadamente recibir los
#      parches más tarde es difícil de justificar en este proyecto.
#   2. MANTENIBILIDAD: quedarse en la rama estable obligaría a añadir a
#      Dependabot una regla que ignorase los saltos de rama, y esa regla
#      también silenciaría el aviso de la siguiente estable (1.32). Es decir,
#      reintroduciría por la puerta de atrás el estancamiento silencioso que
#      dejó esta imagen catorce meses sin actualizar.
#
#  El riesgo de mainline es bajo aquí: nginx solo sirve ficheros estáticos con
#  directivas (listen, root, index, add_header, try_files) que no han cambiado
#  en una década.
#
#  FIJADA POR DIGEST, no por etiqueta. Una etiqueta como "1.31-alpine" es un
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
FROM nginxinc/nginx-unprivileged:1.31-alpine@sha256:b54ac358b83fc6c965793fd271839b4ea4cdb6e99895bb19618cbc2ca152d972

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

# Usuario sin privilegios, declarado EXPLÍCITAMENTE.
#
# La imagen base ya arranca como UID 101, así que esta línea no cambia el
# comportamiento actual. Se añade por dos motivos:
#
#  1. Convierte una propiedad HEREDADA en una garantía propia. Si algún día
#     alguien cambiara el FROM a la imagen oficial de nginx —que arranca como
#     root para poder abrir el puerto 80— este Dockerfile seguiría forzando un
#     usuario sin privilegios en lugar de degradarse en silencio.
#  2. Hace explícita la intención: quien lea el fichero no tiene que ir a
#     inspeccionar la imagen base para saber con qué usuario corre esto.
#
# Va DESPUÉS de los COPY a propósito: las instrucciones COPY las ejecuta el
# constructor, no el usuario del contenedor, y así los ficheros quedan con el
# propietario habitual (root) y permisos de solo lectura para el resto. Es lo
# que nginx necesita, y encaja con el readOnlyRootFilesystem del Deployment.
USER 101

# El puerto es informativo: no publica nada por sí mismo, pero documenta en
# qué puerto escucha el proceso. El Deployment lo declara en containerPort.
EXPOSE 8080
