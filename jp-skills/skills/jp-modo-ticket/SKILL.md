---
name: jp-modo-ticket
description: >-
  Orquestador principal de las JP Skills. Recibe un ticket, requerimiento o
  instrucción, decide qué JP Skills usar (jp-analizar-ticket, jp-analizar-flujo,
  jp-analizar-modulo, jp-impacto-cambio, jp-migrar-flujo, jp-replicar-flujo,
  jp-analizar-rendimiento-query, jp-optimizar-query, jp-reflexion), consolida el análisis y solo
  implementa cuando el usuario lo pide explícitamente. Usar cuando el usuario
  invoque /jp-modo-ticket, pegue un ticket o requerimiento, responda preguntas de
  un análisis previo o diga "implementar".
---

# jp-modo-ticket

Punto de entrada único. Identifica qué necesita el usuario y **delega** en la JP Skill especializada. No duplica la lógica de las demás Skills: las lee y sigue.

## JP Skills disponibles

| Skill | Ruta | Cuándo usarla |
|-------|------|---------------|
| jp-analizar-ticket | `~/.cursor/skills/jp-analizar-ticket/SKILL.md` | Ticket o requerimiento nuevo a analizar |
| jp-analizar-flujo | `~/.cursor/skills/jp-analizar-flujo/SKILL.md` | Entender cómo funciona hoy un proceso o flujo concreto |
| jp-analizar-modulo | `~/.cursor/skills/jp-analizar-modulo/SKILL.md` | Mapear un módulo/pantalla completo (ruta, permisos, vista, API, modelo, tablas) |
| jp-impacto-cambio | `~/.cursor/skills/jp-impacto-cambio/SKILL.md` | Medir efectos secundarios de un cambio |
| jp-migrar-flujo | `~/.cursor/skills/jp-migrar-flujo/SKILL.md` | Llevar una funcionalidad de un proyecto A a un proyecto B |
| jp-replicar-flujo | `~/.cursor/skills/jp-replicar-flujo/SKILL.md` | Crear un CRUD/flujo nuevo "igual a" uno existente del mismo proyecto |
| jp-analizar-rendimiento-query | `~/.cursor/skills/jp-analizar-rendimiento-query/SKILL.md` | Diagnosticar una query, endpoint o proceso lento (sin modificar código) |
| jp-optimizar-query | `~/.cursor/skills/jp-optimizar-query/SKILL.md` | Optimizar una query ya analizada (solo con pedido explícito de optimizar) |
| jp-reflexion | `~/.cursor/skills/jp-reflexion/SKILL.md` | Cierre de un trabajo importante: aprendizajes y mejoras a las Skills |

Antes de aplicar una Skill, **leer su `SKILL.md` completo** con la herramienta de lectura.

`jp-analizar-rendimiento-query` y `jp-optimizar-query` tienen invocación manual: esta Skill solo las aplica cuando el usuario pide expresamente analizar el rendimiento u optimizar. Nunca optimizar sin un análisis previo de rendimiento.

## Paso 1: Clasificar la entrada

| Entrada del usuario | Modo |
|---------------------|------|
| Ticket / requerimiento nuevo | **A. Análisis de ticket** |
| "¿Cómo funciona X?" sin ticket | Delegar directo a `jp-analizar-flujo` |
| "Analiza/documenta/audita el módulo X" | Delegar directo a `jp-analizar-modulo` |
| "¿Qué afecta cambiar X?" | Delegar directo a `jp-impacto-cambio` |
| "Pasar/migrar X del proyecto A al B" | Delegar directo a `jp-migrar-flujo` |
| "Crear un módulo/CRUD igual a X" en el mismo proyecto | Delegar directo a `jp-replicar-flujo` |
| "X está lento / analiza el rendimiento de X" | Delegar directo a `jp-analizar-rendimiento-query` |
| "Optimiza X" (con análisis de rendimiento previo) | Delegar directo a `jp-optimizar-query` |
| Respuestas a preguntas pendientes | **B. Actualización incremental** |
| "implementar" (explícito) | **C. Implementación** |
| Trabajo importante terminado | **D. Reflexión** |

Si la entrada es ambigua entre dos modos, elegir el más conservador (análisis antes que implementación).

## A. Análisis de ticket

1. Aplicar `jp-analizar-ticket` como guía principal del análisis.
2. Para cada punto cuyo comportamiento actual no esté claro, aplicar `jp-analizar-flujo` (solo lo necesario, no todo el sistema); si el ticket abarca una pantalla o módulo completo, usar `jp-analizar-modulo`.
3. Para los puntos que modifican comportamiento existente, aplicar `jp-impacto-cambio`.
   - Si un punto reporta lentitud, marcarlo y sugerir `jp-analizar-rendimiento-query`, sin ejecutarla salvo pedido explícito.
4. Consolidar en una sola respuesta con la salida de `jp-analizar-ticket`:
   - huecos, contradicciones y dependencias;
   - agrupación de requerimientos relacionados;
   - orden de implementación;
   - riesgos (incorporando el impacto medido);
   - preguntas pendientes;
   - estado final.
5. **No implementar.** Terminar indicando que se espera confirmación o respuestas.

Para investigaciones amplias en paralelo puede usarse un subagente `explore`, pero la consolidación y conclusiones son responsabilidad de esta Skill.

## B. Actualización incremental

Cuando el usuario responde preguntas del análisis:

1. Identificar qué puntos/grupos afecta cada respuesta.
2. Actualizar **solo** esos puntos (estado, solicitud, diferencia).
3. Recalcular dependencias, agrupación y orden si cambian.
4. Recalcular riesgos; si la respuesta introduce cambio en un área nueva, aplicar `jp-impacto-cambio` solo sobre ella.
5. Mostrar únicamente:
   - puntos actualizados (antes → ahora);
   - cambios en dependencias, orden o riesgos;
   - preguntas que siguen pendientes o nuevas;
   - nuevo estado final.

No repetir el análisis completo salvo que el usuario lo pida.

## C. Implementación

Solo cuando el usuario diga explícitamente "implementar" (o equivalente inequívoco).

1. Si hay un análisis previo en la conversación, usarlo como plan; si no existe, ejecutar primero el modo A y pedir confirmación.
2. Si quedan preguntas que bloquean un grupo, implementar los grupos no bloqueados y avisar cuáles quedan pendientes.
3. Seguir el orden de implementación definido; un grupo a la vez.
4. Respetar convenciones y arquitectura del proyecto (reglas del repo, patrones existentes).
   - Si un grupo consiste en crear un CRUD/flujo a partir de uno existente, seguir `jp-replicar-flujo`.
   - Si un grupo es una optimización de rendimiento ya analizada, seguir `jp-optimizar-query`.
5. Aplicar validaciones en backend además de frontend cuando una regla restrinja acciones.
6. Mantener trazabilidad: indicar qué punto del ticket cubre cada cambio.
7. Validar al terminar cada grupo (lint, sintaxis, tests existentes si los hay).
8. Resumen final: qué se implementó por punto, qué quedó pendiente y qué debe probarse manualmente.

## D. Reflexión

Al cerrar un trabajo importante (ticket completo, migración, investigación compleja), aplicar `jp-reflexion`. Solo mostrar propuestas si hay mejoras concretas. Nunca modificar Skills sin autorización.

## Principios JP (comunes a todas las JP Skills)

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

```text
ENTENDER → INVESTIGAR → RELACIONAR → DETECTAR HUECOS → MEDIR IMPACTO
→ ORDENAR → IMPLEMENTAR → VALIDAR → APRENDER
```
