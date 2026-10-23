---
name: jp-migrar-flujo
description: >-
  Analiza una funcionalidad, módulo o flujo de un Proyecto A (origen) y lo adapta
  a la arquitectura de un Proyecto B (destino) sin copiar código ciegamente:
  reconstruye el comportamiento original, busca equivalencias en el destino,
  construye una matriz de mapeo origen → destino, clasifica diferencias y propone
  un plan de adaptación. Usar cuando el usuario pida migrar, portar, replicar o
  llevar una funcionalidad de un proyecto/sistema a otro.
---

# jp-migrar-flujo

Principio fundamental: **migrar comportamiento, no archivos.**

No asumir que dos piezas con el mismo nombre (p. ej. `OrderController`) cumplen la misma responsabilidad. Respetar siempre la arquitectura del Proyecto B. No implementar hasta que el usuario lo solicite.

Si no está claro cuál es el origen o el destino (rutas, repositorios), preguntarlo antes de empezar.

## Fase 1 — Proyecto origen

Aplicar `jp-analizar-flujo` (`~/.cursor/skills/jp-analizar-flujo/SKILL.md`) sobre el Proyecto A para reconstruir el comportamiento completo. Identificar:

- entrada;
- reglas;
- datos;
- validaciones;
- estados;
- cálculos;
- dependencias;
- efectos secundarios;
- salida.

## Fase 2 — Proyecto destino

Investigar cómo el Proyecto B resuelve hoy procesos equivalentes. Buscar equivalencias de:

- arquitectura (capas, carpetas, frameworks);
- tablas y modelos;
- servicios y controladores;
- componentes de UI;
- estados y catálogos;
- permisos y roles;
- convenciones de nombres;
- patrones existentes (CRUD, modales, auditoría, multiempresa, etc.).

Tomar como referencia un módulo del destino ya implementado y similar.

## Fase 3 — Comparación

Construir la matriz:

| Concepto | Proyecto A | Proyecto B | Acción |
|---|---|---|---|
| Orden | services_order | orders | Adaptar |
| Estado | DELIVERED | ENTREGADO | Mapear |
| Servicio | ManifestService | DispatchService | Adaptar |

## Fase 4 — Diferencias

Clasificar cada elemento:

```text
EQUIVALENTE
ADAPTABLE
NO EXISTE
INCOMPATIBLE
REQUIERE DECISIÓN
```

## Fase 5 — Propuesta de migración

Determinar:

- qué lógica puede reutilizarse conceptualmente;
- qué debe adaptarse;
- qué debe crearse;
- qué **no** debería copiarse (deuda técnica, acoplamientos, reglas obsoletas del origen);
- qué riesgos existen (aplicar `jp-impacto-cambio` (`~/.cursor/skills/jp-impacto-cambio/SKILL.md`) sobre las piezas existentes del destino que se modificarán).

## Salida

```markdown
## 1. Flujo original (Proyecto A)
## 2. Flujo equivalente en destino (Proyecto B)
## 3. Diferencias
## 4. Mapeo origen → destino
(matriz Concepto | A | B | Acción | Clasificación)
## 5. Elementos faltantes
## 6. Riesgos
## 7. Orden recomendado
## 8. Preguntas pendientes
## 9. Plan de adaptación
Pasos concretos en la arquitectura del destino, separando obligatorio de sugerido.
```

## Principios JP

1. No inventar comportamiento del sistema.
2. Revisar código real antes de afirmar cómo funciona algo.
3. No modificar código durante una fase de análisis salvo autorización.
4. Diferenciar claramente comportamiento actual de comportamiento solicitado.
5. Buscar relaciones entre módulos y no únicamente archivos individuales.
6. Respetar la arquitectura existente.
7. Evitar sobrearquitectura.
8. No duplicar reglas si pueden centralizarse.
9. Mantener trazabilidad con el requerimiento original.
10. No bloquear todo el trabajo por una única duda.
11. Las preguntas deben surgir solo después de investigar.
12. Separar alcance obligatorio de sugerencias.
13. Priorizar comprender antes de implementar.
14. Si otra JP Skill está especializada en la tarea, utilizarla en lugar de duplicar su lógica.
