# jp-cursor-skills

Skills de Cursor del equipo JP.

| Skill | Para qué sirve |
|-------|----------------|
| `jp-modo-ticket` | Orquestador: recibe un ticket, decide qué skills JP usar, consolida el análisis y solo implementa cuando se pide. |
| `jp-analizar-ticket` | Analizar un ticket punto por punto contra el código: estado, dependencias, huecos y orden de implementación. |
| `jp-analizar-flujo` | Ingeniería inversa de un flujo existente siguiendo las llamadas reales del código (sin modificar nada). |
| `jp-analizar-modulo` | Mapear un módulo completo (ruta, permisos, vista, API, modelo, tablas) y detectar riesgos. |
| `jp-impacto-cambio` | Radio de impacto de un cambio: directo, indirecto y riesgo potencial (BAJO / MEDIO / ALTO). |
| `jp-migrar-flujo` | Portar una funcionalidad de un proyecto origen a la arquitectura de un proyecto destino. |
| `jp-replicar-flujo` | Clonar un CRUD o flujo existente hacia una nueva entidad respetando convenciones. |
| `jp-analizar-rendimiento-query` | Diagnosticar el rendimiento de una consulta, endpoint o proceso backend (EXPLAIN, índices, N+1). |
| `jp-optimizar-query` | Optimizar una query previamente analizada validando que el resultado sea idéntico (invocación explícita). |
| `jp-reflexion` | Retrospectiva al cerrar un trabajo: propone mejoras a las skills JP sin modificar archivos. |

## Instalación

### Opción 1: script (recomendada)

```bash
git clone https://github.com/<usuario-u-org>/jp-cursor-skills.git ~/jp-cursor-skills
cd ~/jp-cursor-skills
./install.sh          # enlaces simbólicos: se actualizan con git pull
./install.sh copy     # alternativa: copia los archivos
```

Las skills quedan en `~/.cursor/skills/jp-*`. Reinicia Cursor.

### Opción 2: CLI `skills`

```bash
npx skills add <usuario-u-org>/jp-cursor-skills -a cursor
```

### Opción 3: solo para un proyecto

Copia `skills/jp-*` dentro de `.cursor/skills/` del repositorio del proyecto y súbelo con el proyecto.

## Actualizar

```bash
cd ~/jp-cursor-skills && git pull
```

Con la instalación por enlaces no hace falta volver a ejecutar `install.sh`, salvo que se agreguen skills nuevas.

## Uso

Cursor las aplica automáticamente según la `description` de cada skill, o se pueden invocar en el chat:

```
/jp-analizar-modulo analiza el módulo motivo traslado
```

## Crear una skill nueva

1. Crear `skills/jp-<nombre>/SKILL.md` (nombre en minúsculas con guiones, prefijo `jp-`).
2. Encabezado obligatorio:

```markdown
---
name: jp-<nombre>
description: Qué hace y cuándo debe usarse (en tercera persona, con palabras clave).
---
```

3. Mantener el `SKILL.md` por debajo de ~500 líneas; el detalle extra va en archivos aparte dentro de la misma carpeta.
4. Abrir un PR.
