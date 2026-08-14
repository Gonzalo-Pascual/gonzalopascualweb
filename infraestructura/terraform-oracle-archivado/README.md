# Oracle Cloud — código archivado. NO EJECUTAR.

> **Este stack está fuera de servicio.** Los recursos que creó fueron destruidos
> el **2 de agosto de 2026** y el estado quedó vacío. Se conserva en el
> repositorio como documentación de un camino que se recorrió y se abandonó, no
> como infraestructura activa.
>
> La infraestructura en producción está en
> [`../terraform-hetzner/`](../terraform-hetzner/) y
> [`../terraform-cloudflare/`](../terraform-cloudflare/).

## Por qué existe esta carpeta

El proyecto arrancó sobre **Oracle Cloud Infrastructure (OCI) Always Free**, cuya
capa gratuita permanente ofrecía una máquina ARM de 4 OCPU y 24 GB de RAM sin
coste. Era, sobre el papel, la mejor oferta del mercado.

La red se creó sin ningún problema: red virtual, subred pública, tabla de rutas,
*internet gateway* y lista de seguridad. **La máquina nunca llegó a crearse.**
Durante una semana, cada intento falló por falta de capacidad en la región
`eu-madrid-1`. Se probaron dos salidas y ninguna funcionó:

1. **Renunciar a la ARM y pedir una x86 mínima.** `compute.tf` conserva las dos
   tentativas: la `VM.Standard.A1.Flex` original quedó comentada y sobre ella se
   escribió una `VM.Standard.E2.1.Micro` (1 OCPU, 1 GB), muy inferior pero
   suficiente para arrancar. Tampoco hubo capacidad.
2. **Convertir la cuenta a modalidad de pago**, que da prioridad en la cola de
   asignación manteniendo los recursos *Always Free* sin coste. La conversión no
   llegó a completarse.

Se migró a Hetzner Cloud. El razonamiento completo, con las alternativas
consideradas y las consecuencias, está en el ADR
[`0004-migracion-oracle-a-hetzner.md`](../../docs/bitacora/0004-migracion-oracle-a-hetzner.md).

## Por qué no se borra

Porque documenta una decisión real y su porqué. Un repositorio que solo enseña el
camino que funcionó oculta la mitad del trabajo. Aquí queda constancia de que la
alternativa se evaluó de verdad —no se descartó de oído— y de cuánto costó
descubrir que no era viable.

## Advertencia técnica

**No ejecutes `terraform plan` ni `terraform apply` en este directorio.**

`compute.tf` declara un recurso `oci_core_instance` que no está en el estado,
porque nunca se creó. Un `plan` normal interpretaría que falta y propondría
crearlo, es decir, **intentaría levantar de nuevo la máquina en Oracle**. Si
alguna vez hubiera que revisar algo aquí, hazlo en modo lectura:

```bash
terraform state list      # debe devolver vacío
```

## Qué contiene cada fichero

| Fichero | Contenido |
|---|---|
| `network.tf` | La red que sí se creó: VCN, subred, gateway, tabla de rutas y lista de seguridad |
| `compute.tf` | Los dos intentos de máquina. El primero (ARM A1.Flex) comentado, el segundo (E2.1.Micro) activo. Ninguno llegó a existir |
| `main.tf` | Consulta de los dominios de disponibilidad de la región |
| `providers.tf` | Provider `oracle/oci`, autenticado con el perfil `DEFAULT` de `~/.oci/config` |
| `variables.tf` | Variables del stack, con `eu-madrid-1` como región |
| `terraform.tfstate` | Estado final: **cero recursos**. Prueba de que nada quedó vivo en Oracle |
| `terraform.tfstate.backup` | Estado previo a la destrucción: siete objetos, cinco de ellos recursos de red. **Ninguno es una instancia** — la prueba documental de que la máquina nunca existió |
| `.terraform.lock.hcl` | Versión exacta del provider que se utilizó |

La caché de providers (`.terraform/`, unos 535 MB) se eliminó al archivar el
stack. Se regenera con `terraform init` si alguna vez fuese necesario.
