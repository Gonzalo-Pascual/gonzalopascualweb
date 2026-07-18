# 0001 · Arranque del proyecto y estructura del repositorio

- **Fecha:** 2026-07-18
- **Estado:** Aceptada

> Este documento es una *ADR* (Architecture Decision Record): un registro corto
> de una decisión importante y su porqué. Iremos añadiendo una por cada decisión
> relevante. Juntas forman la memoria del proyecto (y la base de mi informe).

## Contexto

Quiero una web pública para mi portfolio que me sirva para **demostrar**
conocimientos de SecDevOps, cloud y CI/CD. Requisito nº1: **gratis para siempre**
y sin riesgo de factura. La app es ligera; el objetivo es el proceso.

## Decisión

1. **Backbone Oracle Cloud (Always Free) + Cloudflare**, en lugar de AWS/Azure,
   porque sus capas gratuitas de cómputo caducan o pueden facturar. Oracle ofrece
   una VM ARM (4 vCPU / 24 GB) gratis de forma permanente.
2. **Monorepo**: aplicaciones, infraestructura, despliegue y documentación en un
   único repositorio.
3. **Estructura por responsabilidades**: `apps/`, `infra/` (terraform + ansible),
   `k8s/`, `docs/`, `.github/`.
4. **Higiene desde el inicio**: `.gitignore` (los secretos nunca entran a git),
   `.gitattributes` (finales de línea LF para evitar fallos Windows→Linux) y
   `.editorconfig` (formato consistente).

## Alternativas consideradas

- **AWS/Azure como base:** descartado por riesgo de factura y capas gratis
  temporales. Se podrán usar más adelante para *demostrar* con servicios
  siempre-gratis, no como base.
- **Multi-repo (un repo por componente):** descartado; para una sola persona
  añade fricción sin beneficio. Un cambio y su despliegue viven en el mismo commit.

## Consecuencias

- El único gasto recurrente será el dominio `gonzalopascual.es` (~10-15 €/año).
- La estructura ya nace preparada para añadir en el futuro una app interna real
  (solo será una carpeta más en `apps/`).
- Trabajo en Windows pero despliego en Linux: `.gitattributes` con `eol=lf` evita
  errores sutiles en contenedores.
