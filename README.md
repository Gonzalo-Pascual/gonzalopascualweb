# gonzalopascual.es — Plataforma de portfolio

Web personal desplegada con un stack completo de **SecDevOps + Cloud + CI/CD**,
con el objetivo de *demostrar* en la práctica el ciclo de vida seguro de una
aplicación en producción: desde el código hasta el despliegue observado y
protegido.

> La aplicación en sí es ligera a propósito. El valor de este proyecto está en
> **cómo** se construye, se asegura y se opera, no en cuántas visitas tiene.

**En producción:** https://gonzalopascual.es

## Qué contiene

| Componente | Descripción |
|---|---|
| **Portfolio** | Web estática personal (`apps/porfolio/`). Desplegada. |
| **Mini-API** | Backend del formulario de contacto (`apps/api/`). En construcción. |

## Stack

- **Infraestructura:** Hetzner Cloud (VM CX23, Ubuntu 24.04) + Cloudflare.
  Se partió de Oracle Cloud *Always Free* y se migró; el porqué está en el
  ADR [0004](docs/bitacora/0004-migracion-oracle-a-hetzner.md).
- **IaC:** Terraform (aprovisiona Hetzner y el DNS de Cloudflare) + Ansible
  (configura y bastiona el sistema operativo).
- **Contenedores y orquestación:** Docker + k3s (Kubernetes ligero), con
  Traefik como Ingress Controller.
- **TLS:** cert-manager + Let's Encrypt vía reto ACME **DNS-01**, con
  Cloudflare en modo **Full (strict)**.
- **CI/CD:** GitHub Actions (principal) + ArgoCD (GitOps). *Pendiente.*
- **Seguridad:** escaneo en el pipeline (SAST, IaC, imágenes, secretos) y
  defensa en runtime. *Parcial.*
- **Observabilidad:** Prometheus + Grafana. *Pendiente.*

## Postura de seguridad actual

- Cortafuegos perimetral que **cierra el bypass del origen**: 80/443 solo
  aceptan tráfico de rangos de Cloudflare; 22 e ICMP, solo desde la IP de
  administración.
- La **API de Kubernetes no está expuesta**: se accede por túnel SSH.
- SSH endurecido (sin contraseñas, sin login root interactivo), `fail2ban` y
  actualizaciones de seguridad desatendidas.
- Contenedor **sin root**, con sistema de ficheros de solo lectura, todas las
  capacidades del kernel retiradas y perfil `seccomp` por defecto.
- **TLS verificado extremo a extremo**, con renovación automática, HSTS y
  cabeceras de seguridad en dos capas (borde y origen).
- El portfolio **no hace ninguna petición a servidores externos** para
  renderizarse: fuentes e iconos auto-alojados, compatible con una CSP estricta.

## Estructura del repositorio

```
apps/                              # código de las aplicaciones
  porfolio/                        #   web estática + Dockerfile + nginx.conf
  api/                             #   mini-API de contacto (FastAPI)
infraestructura/
  terraform-hetzner/               #   VM y cortafuegos perimetral
  terraform-cloudflare/            #   registros DNS y ajustes de seguridad de zona
  terraform-oracle-archivado/      #   intento inicial en OCI (ver ADR 0004)
  ansible/                         #   bastionado del SO e instalación de k3s
k8s/
  portfolio/                       #   Deployment, Service, Ingress, Middleware
  cert-manager/                    #   instalación y emisores ACME
docs/bitacora/                     # ADRs: el "por qué" de cada decisión
.github/                           # pipelines de integración continua (pendiente)
```

## Estado

🚧 En construcción. La web está **publicada y operativa**; falta el pipeline de
CI/CD, GitOps, la API de contacto y la observabilidad.

Las decisiones razonadas, con sus alternativas descartadas y sus consecuencias,
están en [`docs/bitacora/`](docs/bitacora/).
