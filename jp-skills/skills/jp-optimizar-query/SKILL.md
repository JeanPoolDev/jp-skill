---
name: jp-optimizar-query
description: >-
  Optimiza una consulta, endpoint o proceso backend previamente analizado
  (idealmente con jp-analizar-rendimiento-query) aplicando prácticas
  profesionales de backend y base de datos: elimina N+1 y queries repetidas,
  selecciona columnas, revisa índices, paginación y procesamiento, y valida que
  el resultado optimizado sea idéntico al anterior. Solo usar cuando el usuario
  invoque explícitamente /jp-optimizar-query.
disable-model-invocation: true
---

# jp-optimizar-query

## Objetivo

Optimizar una consulta, endpoint o proceso backend previamente analizado, utilizando prácticas profesionales de backend y base de datos.

La prioridad es obtener mejor rendimiento **sin modificar accidentalmente el comportamiento funcional existente**.

---

## Requisito previo

Antes de modificar código reconstruir o recuperar el contrato actual del endpoint.

Debe conocerse:

- campos entregados;
- relaciones;
- cálculos;
- filtros;
- orden;
- paginación;
- reglas de negocio.

Si existe análisis previo de `jp-analizar-rendimiento-query` (`~/.cursor/skills/jp-analizar-rendimiento-query/SKILL.md`), utilizarlo como referencia. Si no existe, ejecutar primero sus fases 1 a 3 (reconstruir endpoint, inventario de datos, consultas reales) antes de tocar código.

---

## Regla crítica

Una optimización no es correcta solamente porque sea más rápida.

Debe cumplir:

```text
RESULTADO ANTERIOR
       =
RESULTADO OPTIMIZADO
```

salvo cambios explícitamente autorizados.

---

## Estrategias profesionales a evaluar

### Consultas

- evitar N+1;
- eager loading selectivo;
- joins apropiados;
- eliminar consultas repetidas;
- eliminar queries dentro de loops;
- utilizar agregaciones SQL cuando corresponda;
- evitar recuperar información que después se descarta.

### Columnas

Evitar `SELECT *` cuando sea viable.

Seleccionar solo columnas realmente requeridas, incluyendo aquellas necesarias para:

- relaciones;
- cálculos;
- serialización;
- transformaciones.

Nunca eliminar una columna simplemente porque no aparece directamente en la vista.

### Relaciones

Evaluar (o su equivalente en el ORM / query builder del proyecto, p. ej. en CodeIgniter 4: joins, `whereIn` con ids precargados, subconsultas, `selectCount`):

- `with`;
- `load`;
- joins;
- subqueries;
- `withCount`;
- `exists`;
- consultas agregadas.

Elegir según el caso real. No utilizar eager loading indiscriminadamente.

---

## Índices

Revisar consultas reales antes de proponer:

- índices simples;
- índices compuestos;
- índices para joins;
- índices para filtros frecuentes.

Cualquier SQL estructural nuevo (`CREATE INDEX`, `ALTER TABLE`, tablas auxiliares) debe mostrarse claramente al usuario antes de ejecutarse, salvo que exista autorización explícita.

---

## Paginación

Cuando el endpoint maneje grandes cantidades de información, evaluar:

- paginación tradicional;
- `simplePaginate`;
- cursor pagination;
- procesamiento por chunks.

No cambiar el tipo de paginación si altera el contrato del consumidor sin advertirlo (por ejemplo, DataTables server-side espera `draw`, `recordsTotal`, `recordsFiltered`, `data`).

---

## Procesamiento backend

Buscar lógica como:

```text
query
  ↓
traer miles de registros
  ↓
foreach
  ↓
filtrar
  ↓
calcular
```

Evaluar si parte del trabajo puede realizarse correctamente en la base de datos.

No mover reglas complejas a SQL si reduce significativamente la claridad o rompe la arquitectura existente.

---

## Caching

Considerar caching únicamente cuando:

- los datos no cambien constantemente;
- exista una estrategia clara de invalidación;
- el costo de recalcular sea significativo.

No utilizar caché como primera solución para ocultar una query deficiente. Primero optimizar la consulta.

---

## Comparación obligatoria

Antes y después de optimizar comparar, cuando sea posible:

```text
Cantidad de queries
Tiempo de ejecución
Registros procesados
Memoria
Plan de ejecución
```

---

## Verificación funcional

Comparar respuesta anterior contra respuesta optimizada.

Validar:

- mismos campos;
- mismos tipos;
- mismas relaciones;
- mismos filtros;
- mismo orden;
- mismos cálculos;
- misma cantidad de resultados;
- misma lógica de permisos.

Si existe una diferencia, detenerse y explicarla.

---

## Evitar micro-optimizaciones

Priorizar problemas reales. Orden recomendado:

```text
1. N+1
2. Queries repetidas
3. Queries costosas
4. Índices
5. Volumen recuperado
6. Procesamiento backend
7. Serialización
8. Cache
```

No complicar código por mejoras insignificantes.

---

# Salida antes de implementar

Mostrar y esperar confirmación del usuario antes de modificar código:

## Problema actual

Qué causa lentitud.

## Optimización propuesta

Qué se cambiará.

## Datos preservados

Qué debe seguir devolviendo exactamente el endpoint.

## Riesgo

```text
BAJO
MEDIO
ALTO
```

## Mejora esperada

Expresarla cualitativamente o utilizando métricas reales.

---

# Validación después de implementar

| Métrica | Antes | Después |
|---|---:|---:|
| Queries | X | Y |
| Tiempo | X | Y |
| Registros | X | Y |

Solo incluir métricas realmente medidas.

Después validar:

```text
✅ Contrato de respuesta conservado
✅ Filtros conservados
✅ Relaciones conservadas
✅ Reglas de negocio conservadas
✅ Sin N+1 nuevo
```

Si algún punto no pudo verificarse, marcarlo como pendiente y explicar por qué; nunca marcarlo como ✅ sin evidencia.

---

# Principio final

La prioridad de esta Skill es:

```text
NO hacer:

QUERY RÁPIDA
    +
SISTEMA ROTO
```

Debe conseguir:

```text
MISMO RESULTADO
       ↓
MENOS CONSULTAS
       ↓
MENOS DATOS INNECESARIOS
       ↓
MEJOR PLAN DE EJECUCIÓN
       ↓
MENOR TIEMPO DE RESPUESTA
       ↓
CÓDIGO MANTENIBLE
```

Optimizar primero los cuellos de botella demostrables y mantener siempre la compatibilidad funcional del endpoint.
