---
name: jp-impacto-cambio
description: >-
  Determina el radio de impacto de una modificación antes de implementarla:
  busca llamadores, usos de la entidad, consultas, componentes reutilizados,
  endpoints, jobs, reportes, permisos, estados e integraciones, y clasifica el
  impacto en directo, indirecto y riesgo potencial con nivel BAJO, MEDIO, ALTO o
  REQUIERE VALIDACIÓN. Usar cuando el usuario pregunte qué afecta un cambio,
  antes de modificar comportamiento existente, o cuando lo delegue otra JP Skill.
---

# jp-impacto-cambio

Pregunta central: **Si modificamos esto, ¿qué otras partes del sistema podrían verse afectadas?**

No modificar código.

## Proceso

1. **Definir el objeto del cambio:** método, endpoint, tabla/columna, entidad, estado, regla o componente. Si su comportamiento actual no está claro, aplicar primero `jp-analizar-flujo` (`~/.cursor/skills/jp-analizar-flujo/SKILL.md`).
2. **Buscar usos reales** (búsqueda textual y por símbolo, incluyendo variantes de nombre: snake_case, camelCase, strings en SQL, rutas en JS):
   - quién llama ese método;
   - dónde más se usa la entidad / tabla / columna;
   - consultas relacionadas (SQL crudo, query builders, vistas, procedimientos);
   - componentes reutilizados (modales, helpers, servicios compartidos);
   - validaciones duplicadas en varios lugares;
   - frontend y backend relacionados;
   - endpoints y APIs (internas y expuestas a terceros);
   - jobs, crons, procesos masivos, importaciones;
   - eventos y listeners;
   - reportes, PDF, Excel, dashboards;
   - estados y transiciones dependientes;
   - permisos y roles;
   - integraciones externas;
   - tests existentes.
3. **Construir el árbol de impacto:**

   ```text
   deleteOrder()
        │
        ├── Órdenes
        ├── Manifiesto
        ├── Desembarque
        ├── Reparto
        ├── API
        └── Proceso masivo
   ```

4. **Clasificar** cada elemento encontrado.

## Clasificación

- **Impacto directo:** código que necesariamente será modificado.
- **Impacto indirecto:** código que depende del comportamiento modificado (no se edita, pero su resultado cambia).
- **Riesgo potencial:** código que podría verse afectado y requiere validación.

Nivel de riesgo por elemento:

```text
BAJO
MEDIO
ALTO
REQUIERE VALIDACIÓN
```

No afirmar que algo se romperá sin evidencia. Si no hay evidencia suficiente, usar `REQUIERE VALIDACIÓN` y decir qué habría que comprobar.

## Regla especial: Frontend y Backend

Cuando una regla limite una acción del usuario (bloquear, ocultar, deshabilitar, restringir por estado o permiso), verificar si la validación existe en:

```text
Frontend
Backend
```

Ocultar o deshabilitar visualmente **no** es suficiente. Reportar explícitamente cuando falte la validación backend y listar todos los endpoints que permiten la misma acción (incluidos API, procesos masivos e importaciones).

## Salida

```markdown
## Impacto: <cambio>

### Objeto del cambio
Qué se modifica y cómo funciona hoy (breve, con referencia a código).

### Árbol de impacto
<diagrama>

### Detalle
| Elemento | Ubicación | Tipo (directo/indirecto/potencial) | Riesgo | Evidencia / qué validar |

### Validación Frontend / Backend
| Regla | Frontend | Backend | Observación |

### Recomendaciones
Separar lo obligatorio de lo sugerido.

### Pruebas sugeridas
Escenarios concretos a validar tras el cambio.
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
