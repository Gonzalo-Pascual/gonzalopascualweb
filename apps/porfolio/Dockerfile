FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/
COPY css/       /usr/share/nginx/html/css/
COPY js/        /usr/share/nginx/html/js/
COPY imagenes/  /usr/share/nginx/html/imagenes/
COPY vendor/    /usr/share/nginx/html/vendor/
COPY CV_Gonzalo_Pascual_Romero_2024.pdf /usr/share/nginx/html/

