---
name: jp-reflexion
description: >-
  Analiza lo aprendido tras un ticket, implementación, migración o investigación
  y propone mejoras concretas a las JP Skills (reglas faltantes, nuevas Skills,
  responsabilidades mal repartidas) sin modificar ningún archivo. Usar al cerrar
  un trabajo importante, cuando el usuario pida una retrospectiva o reflexión, o
  cuando lo delegue jp-modo-ticket.
---

# jp-reflexion

Detecta mejoras para las JP Skills a partir del trabajo realizado en la conversación.

**Nunca modificar automáticamente archivos de Skills.** Esperar siempre autorización explícita del usuario.

## Revisión interna

Repasar la conversación y preguntarse:

- ¿Qué problema apareció que las Skills actuales no contemplaban?
- ¿Qué análisis tuvimos que hacer manualmente?
- ¿Qué error podría repetirse en otros proyectos?
- ¿Qué regla habría evitado retrabajo?
- ¿Existe un patrón frecuente?
- ¿Una Skill está adquiriendo demasiadas responsabilidades?
- ¿Conviene crear una nueva Skill especializada?

Para comparar contra lo que ya dicen las Skills, leer las afectadas en `~/.cursor/skills/jp-*/SKILL.md`. No proponer reglas que ya existen.

## Salida

Solo mostrar propuestas si existe una mejora concreta y generalizable (no específica de un único proyecto). Si no hay ninguna, decirlo en una línea.

Por cada propuesta:

```markdown
### Situación detectada
Qué ocurrió.

### Problema de la Skill actual
Qué instrucción faltó o fue insuficiente.

### Mejora propuesta
Regla concreta que podría agregarse (redactada lista para pegar).

### Skill afectada
jp-...

### Beneficio
Qué problema evitaría.

### ¿Crear nueva Skill?
SÍ / NO
(Si SÍ: nombre sugerido con prefijo jp- y responsabilidad en 1–2 líneas.)
```

Terminar preguntando qué propuestas desea aplicar el usuario.

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
