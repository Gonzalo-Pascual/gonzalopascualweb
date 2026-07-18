# gonzalopascual.es — Plataforma de portfolio

Web personal desplegada con un stack completo de **SecDevOps + Cloud + CI/CD**,
con el objetivo de *demostrar* en la práctica el ciclo de vida seguro de una
aplicación en producción: desde el código hasta el despliegue observado y
protegido.

> La aplicación en sí es ligera a propósito. El valor de este proyecto está en
> **cómo** se construye, se asegura y se opera, no en cuántas visitas tiene.

## Qué contiene

| Componente | Descripción |
|---|---|
| **Portfolio** | Web estática personal (`apps/portfolio/`). |
| **Mini-API** | Backend del formulario de contacto (`apps/api/`). |

## Stack

- **Infraestructura (gratis para siempre):** Oracle Cloud *Always Free* (VM ARM) + Cloudflare.
- **IaC:** Terraform (aprovisiona) + Ansible (configura y asegura).
- **Contenedores y orquestación:** Docker + k3s (Kubernetes ligero).
- **CI/CD:** GitHub Actions (principal) + Jenkins (secundario) + ArgoCD (GitOps).
- **Seguridad:** escaneo en el pipeline (SAST, IaC, imágenes, secretos) y defensa en runtime.
- **Observabilidad:** Prometheus + Grafana.

## Estructura del repositorio

```
apps/       # el código de las aplicaciones (portfolio y api)
infra/      # infraestructura como código (terraform, ansible)
k8s/        # manifiestos de Kubernetes y GitOps
docs/       # bitácora de decisiones (el "por qué" de cada paso)
.github/    # pipelines de integración continua
```

## Estado

🚧 En construcción — **Fase 0: fundamentos**. Ver el progreso y las decisiones
razonadas en [`docs/bitacora/`](docs/bitacora/).
