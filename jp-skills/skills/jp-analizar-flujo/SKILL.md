---
name: jp-analizar-flujo
description: >-
  Realiza ingeniería inversa funcional y técnica de un módulo, proceso o flujo
  existente siguiendo las llamadas reales del código (rutas, controladores,
  servicios, modelos, vistas, JS, APIs, jobs, eventos, validaciones, estados,
  tablas, reportes) para responder "¿cómo funciona realmente esto hoy?". No
  modifica código. Usar cuando el usuario pregunte cómo funciona algo, pida
  entender un flujo antes de cambiarlo, o cuando lo delegue otra JP Skill.
---

# jp-analizar-flujo

Pregunta central: **¿Cómo funciona realmente esto actualmente?**

No modificar código. No proponer cambios salvo que el usuario lo pida.

## Proceso

1. **Delimitar** el flujo solicitado (punto de entrada y resultado esperado). Investigar solo lo necesario para reconstruirlo.
2. **Encontrar el punto de entrada:** pantalla, botón, ruta, endpoint, comando, job o evento.
3. **Seguir las llamadas reales** paso a paso. No asumir comportamiento por nombres de archivos o métodos: abrir y leer el código invocado.
4. Revisar según corresponda:
   - rutas, middleware, policies, permisos;
   - controladores, servicios, repositorios, helpers;
   - modelos, consultas, tablas, relaciones, triggers;
   - validaciones (frontend y backend), enums, estados;
   - vistas, componentes, JavaScript, llamadas AJAX/API;
   - jobs, eventos, listeners, colas, crons;
   - reportes, PDF, Excel, integraciones externas;
   - auditoría/bitácora.
5. **Registrar evidencia:** cada afirmación respaldada con `archivo:método` o líneas.
6. Marcar como **no verificado** lo que no se pudo confirmar en el código (p. ej. lógica en BD, servicio externo, código no disponible).

## Reconstrucción

Mostrar el flujo así (adaptar a lo real):

```text
ENTRADA (pantalla / acción del usuario / API)
   ↓
Ruta / acción
   ↓
Controller
   ↓
Service
   ↓
Validaciones
   ↓
Modelo / consultas
   ↓
Base de datos
   ↓
Procesos relacionados
   ↓
SALIDA
```

## Debe identificar

- dónde inicia;
- qué métodos participan (en orden);
- qué información recibe (parámetros, payload, sesión, constantes de contexto);
- qué validaciones aplica y dónde (frontend / backend);
- qué datos lee y modifica (tablas, columnas);
- qué estados cambia (antes → después);
- qué otras operaciones ejecuta (transacciones, auditoría, eventos, integraciones);
- qué sucede al finalizar (respuesta, redirección, mensajes, archivos generados);
- manejo de errores relevante.

## Salida

```markdown
## Flujo: <nombre>

### Resumen

Qué hace el flujo en 2–4 líneas.

### Diagrama

<diagrama de texto>

### Paso a paso

1. <archivo:método> — qué hace.

### Datos

| Tabla | Lee / Escribe | Campos relevantes |

### Validaciones

| Regla | Frontend | Backend |

### Estados

<transiciones>

### Procesos relacionados y efectos secundarios

### No verificado / dudas
```

Puede usarse de forma independiente o como apoyo de `jp-analizar-ticket`, `jp-impacto-cambio` y `jp-migrar-flujo`.

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
