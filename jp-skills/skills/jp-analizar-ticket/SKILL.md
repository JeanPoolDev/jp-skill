---
name: jp-analizar-ticket
description: >-
  Analiza profesionalmente un ticket o requerimiento de software antes de
  modificar código: punto por punto compara lo solicitado contra lo que existe en
  el código, clasifica el estado, detecta dependencias, relaciones, huecos y
  contradicciones, agrupa requerimientos y propone orden de implementación. Usar
  cuando el usuario pegue un ticket, historia de usuario o lista de
  requerimientos y pida analizarlo, o cuando lo delegue jp-modo-ticket.
---

# jp-analizar-ticket

Transforma un ticket en un plan técnico y funcional entendible. **No** se limita a repetir los puntos. **No** modifica código.

## Proceso

### 1. Lectura global

Leer el ticket completo antes de analizar cualquier punto. Identificar:

- objetivo general (qué problema de negocio resuelve);
- módulos involucrados;
- entidades involucradas;
- reglas de negocio;
- procesos relacionados.

### 2. Análisis punto por punto

Para cada punto del ticket:

- **Solicitud:** qué pide realmente (reformulado sin ambigüedad).
- **Situación actual:** qué existe hoy según el código, con referencia a archivos/métodos. Si no está claro, aplicar `jp-analizar-flujo` (`~/.cursor/skills/jp-analizar-flujo/SKILL.md`) solo sobre ese flujo.
- **Diferencia:** qué tendría que cambiar.
- **Estado:**

  ```text
  YA EXISTE
  EXISTE PARCIALMENTE
  NO EXISTE
  REQUIERE MODIFICACIÓN
  REQUIERE CONFIRMACIÓN
  ```

- **Dependencias:** de qué otros puntos (o piezas existentes) depende.
- **Impacto:** si modifica comportamiento existente, aplicar `jp-impacto-cambio` (`~/.cursor/skills/jp-impacto-cambio/SKILL.md`) y resumir el resultado.

### 3. Relaciones

Detectar puntos separados que en realidad pertenecen al mismo flujo (misma entidad, mismo estado, misma pantalla, misma regla).

### 4. Huecos

Buscar activamente:

- reglas incompletas;
- casos no definidos (vacíos, nulos, duplicados, permisos, multiempresa);
- contradicciones entre puntos o con reglas existentes;
- estados faltantes o transiciones no definidas;
- comportamiento ambiguo;
- casos límite.

### 5. Agrupación

Agrupar puntos que deban implementarse juntos:

```text
Punto 1 ─┐
Punto 5 ─┼── Grupo A: <nombre del flujo>
Punto 8 ─┘
```

### 6. Orden

Definir el orden de implementación por dependencias técnicas y funcionales (modelo de datos → reglas backend → endpoints → frontend → reportes), **no** por el orden numérico del ticket.

## Preguntas

Antes de preguntar algo que no está escrito:

1. buscar en el ticket;
2. buscar en el código;
3. buscar procesos equivalentes en el sistema;
4. revisar reglas existentes.

Preguntar solo cuando exista una decisión funcional que realmente no pueda deducirse. Si se deduce, indicarlo como **supuesto** explícito.

Una duda en un punto no detiene el análisis de los demás: marcar el punto como `REQUIERE CONFIRMACIÓN` y continuar.

Cada pregunta debe indicar: punto afectado, por qué no se pudo deducir, y opciones concretas cuando existan.

## Salida

Usar esta estructura:

```markdown
## 1. Resumen general
Objetivo, módulos, entidades y alcance en pocas líneas.

## 2. Análisis punto por punto
### Punto N — <título>
- Solicitud:
- Situación actual: (con referencias a código)
- Diferencia:
- Estado:
- Dependencias:
- Huecos / supuestos:

## 3. Relaciones encontradas

## 4. Agrupación recomendada

## 5. Orden de implementación

## 6. Preguntas pendientes

## 7. Riesgos
Separar alcance obligatorio de sugerencias opcionales.

## 8. Estado final
LISTO PARA IMPLEMENTAR | LISTO CON OBSERVACIONES | REQUIERE CONFIRMACIÓN | REQUIERE REVISIÓN DEL TICKET
```

Criterio del estado final:

- **LISTO PARA IMPLEMENTAR:** sin preguntas ni riesgos relevantes.
- **LISTO CON OBSERVACIONES:** implementable; hay supuestos o riesgos menores declarados.
- **REQUIERE CONFIRMACIÓN:** hay decisiones funcionales pendientes que bloquean al menos un grupo.
- **REQUIERE REVISIÓN DEL TICKET:** contradicciones graves u objetivo poco claro.

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
