---
name: jp-analizar-rendimiento-query
description: >-
  Analiza (sin modificar código) el rendimiento de una consulta, endpoint o
  proceso backend lento con grandes volúmenes de datos: reconstruye el flujo,
  inventaría el contrato de datos entregado, detecta N+1, queries repetidas,
  SELECT *, índices faltantes y procesamiento costoso, y estima el potencial de
  mejora. Solo usar cuando el usuario invoque explícitamente
  /jp-analizar-rendimiento-query.
disable-model-invocation: true
---

# jp-analizar-rendimiento-query

## Objetivo

Analizar el rendimiento de una consulta, endpoint o proceso backend que presenta lentitud con grandes volúmenes de datos.

Esta Skill **NO debe modificar código**.

Su objetivo es determinar:

1. Por qué el endpoint es lento.
2. Qué consultas ejecuta realmente.
3. Qué datos entrega actualmente.
4. Qué datos son obligatorios conservar.
5. Qué relaciones y cálculos utiliza.
6. Qué parte genera mayor costo.
7. Cuánto margen razonable de optimización existe.
8. Qué estrategias podrían aplicarse posteriormente.

---

## Regla principal

Antes de sugerir cualquier optimización debes entender completamente el contrato actual del endpoint.

Nunca optimizar una consulta eliminando información que actualmente utiliza:

- frontend;
- API;
- aplicación móvil;
- reportes;
- exportaciones;
- procesos internos;
- otras funciones.

La prioridad es:

```text
MEJORAR RENDIMIENTO
        +
MANTENER EL MISMO RESULTADO FUNCIONAL
```

Para encontrar consumidores del endpoint (vistas JS, app móvil, reportes, exportaciones) puede apoyarse en `jp-impacto-cambio` (`~/.cursor/skills/jp-impacto-cambio/SKILL.md`) y, si el flujo no está claro, en `jp-analizar-flujo` (`~/.cursor/skills/jp-analizar-flujo/SKILL.md`).

---

## Fase 1 — Reconstruir el endpoint

Identificar:

```text
Route
  ↓
Controller
  ↓
Service / Repository
  ↓
Query
  ↓
Models / relaciones
  ↓
Transformaciones
  ↓
Response
```

Determinar:

- parámetros recibidos;
- filtros;
- ordenamiento;
- paginación;
- joins;
- relaciones;
- subconsultas;
- cálculos;
- agrupaciones;
- transformaciones posteriores.

---

## Fase 2 — Inventario de datos entregados

Antes de analizar rendimiento construir una lista de todo lo que devuelve actualmente el endpoint.

Ejemplo:

| Campo | Origen | Obligatorio |
|---|---|---|
| id | orders.id | Sí |
| cliente | clients.name | Sí |
| conductor | drivers.name | Sí |
| estado | orders.status | Sí |
| total | cálculo | Sí |
| documentos | relación | Sí |

También identificar:

- campos calculados;
- atributos agregados;
- accessors;
- relaciones anidadas;
- conteos;
- estados derivados;
- transformaciones realizadas después de consultar BD.

Esto servirá como **contrato de salida**.

Ninguna optimización posterior debe perder estos datos sin autorización.

---

## Fase 3 — Analizar consultas reales

Investigar:

- cantidad de queries;
- queries dentro de loops;
- N+1;
- joins innecesarios;
- relaciones cargadas innecesariamente;
- `SELECT *`;
- subqueries costosas;
- `COUNT`;
- `GROUP BY`;
- `DISTINCT`;
- `ORDER BY`;
- búsquedas con `%texto%`;
- filtros sin índices;
- funciones aplicadas sobre columnas;
- consultas repetidas;
- consultas ejecutadas varias veces con los mismos datos;
- cálculos realizados registro por registro.

Cuando sea posible revisar el plan de ejecución mediante herramientas apropiadas como:

```text
EXPLAIN
EXPLAIN ANALYZE
```

No ejecutar comandos destructivos. Solo lecturas (`SELECT`, `EXPLAIN`, `SHOW INDEX`, `SHOW CREATE TABLE`). Nunca `INSERT`, `UPDATE`, `DELETE`, `ALTER`, `DROP`, `TRUNCATE` ni `CREATE INDEX`.

---

## Fase 4 — Revisar volumen

Determinar si el problema aparece por:

- cantidad total de registros;
- cantidad retornada por petición;
- cantidad de relaciones;
- tamaño de columnas;
- falta de paginación;
- consultas repetidas;
- procesamiento en PHP/backend;
- serialización;
- cálculos posteriores.

Diferenciar:

```text
PROBLEMA DE BASE DE DATOS
PROBLEMA DE BACKEND
PROBLEMA DE SERIALIZACIÓN
PROBLEMA DE DISEÑO DEL ENDPOINT
COMBINACIÓN
```

---

## Fase 5 — Índices

Analizar columnas utilizadas frecuentemente en:

```text
WHERE
JOIN
ORDER BY
GROUP BY
```

Revisar índices existentes antes de recomendar nuevos.

No asumir que agregar un índice siempre mejora el rendimiento.

Indicar:

- índice existente;
- índice faltante;
- posible índice compuesto;
- orden recomendado de columnas;
- motivo.

No crear índices durante esta Skill.

---

## Fase 6 — Detectar oportunidades

Clasificar oportunidades.

### Bajo riesgo

- eliminar queries duplicadas;
- eager loading correcto;
- evitar N+1;
- seleccionar columnas necesarias;
- reutilizar datos ya obtenidos.

### Riesgo medio

- cambiar joins;
- reemplazar subqueries;
- reorganizar agregaciones;
- modificar estrategia de carga de relaciones.

### Riesgo alto

- modificar estructura de respuesta;
- precalcular información;
- introducir tablas auxiliares;
- caching persistente;
- modificar reglas de negocio.

---

## Fase 7 — Estimar potencial de mejora

No inventar porcentajes exactos sin mediciones.

Clasificar como:

```text
BAJO
MEDIO
ALTO
MUY ALTO
```

Ejemplo:

> Potencial: ALTO
>
> Motivo: se detectaron 250 consultas adicionales por petición debido a un problema N+1.

Si existen métricas reales, mostrar:

```text
Consultas actuales: 312
Consultas potenciales: ~8

Tiempo actual medido: 4.8 s
```

No prometer tiempos futuros sin medir la implementación.

---

# Salida obligatoria

## 1. Endpoint analizado

Indicar endpoint y flujo.

## 2. Contrato actual de datos

Mostrar todos los datos relevantes que deben conservarse.

## 3. Cuello de botella

Explicar dónde está el problema.

## 4. Hallazgos

| Hallazgo | Impacto | Riesgo |
|---|---|---|
| N+1 en conductores | Alto | Bajo |
| SELECT * | Medio | Bajo |
| Falta índice | Alto | Medio |

## 5. Potencial de mejora

```text
BAJO / MEDIO / ALTO / MUY ALTO
```

Explicar brevemente.

## 6. Estrategias posibles

Solo mencionar qué podría hacerse. No implementar.

## 7. Datos que no deben perderse

Mostrar explícitamente el contrato que una futura optimización deberá respetar.

## 8. Estado

Finalizar con:

```text
LISTO PARA OPTIMIZAR
```

o:

```text
REQUIERE MÁS INFORMACIÓN
```

Si el estado es `LISTO PARA OPTIMIZAR`, indicar que el siguiente paso es `/jp-optimizar-query`, usando este análisis como referencia.
