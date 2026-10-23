---
name: jp-analizar-modulo
description: Analiza un módulo completo del sistema (vista JS, ruta hash, permisos, controladores CodeIgniter 4, modelo y tablas) y entrega un mapa del flujo de datos, dependencias y riesgos. Usar cuando el usuario pida entender, documentar, auditar o revisar un módulo, menú o pantalla antes de modificarlo.
---

# Analizar módulo

## Flujo

1. **Identificar el módulo** por ruta hash (`#/configuracion/...`), permiso, nombre de menú o carpeta.
2. **Recorrer las capas** en este orden y registrar cada archivo encontrado:

| Capa | Dónde buscar |
|------|--------------|
| Ruta | `app/routes/*.js` (permiso `menu`, `router.get`, import dinámico) |
| Menú | `app/views/componentes/Menu_sidebar.js` (`sidebar-...`) |
| Permisos | `app/views/configuracion/Rol.js` (`data-menu="..."`) |
| Vista | `app/views/{grupo}/{camelCase}/Index.js` + `Index.html.js` + modales |
| API | URLs `BASE_API` usadas en la vista → `server/app/Controllers/...` |
| Lógica | `Listar.php`, `Guardar.php`, `Eliminar.php` u otros |
| Modelo | `server/app/Models/...` (`$table`, `$allowedFields`) |
| BD | tablas y joins reales de las queries |

3. **Trazar el flujo** de cada acción (listar, crear, editar, eliminar, acciones extra): botón → evento JS → endpoint → método PHP → queries → respuesta → refresco de UI.
4. **Detectar riesgos** con la checklist.
5. **Entregar el informe** con el formato de abajo. No modificar código salvo que el usuario lo pida.

## Checklist de riesgos

- [ ] Endpoints sin `validar_permisos` o con permiso distinto al del menú.
- [ ] Queries sin filtro `id_empresa` / `ID_EMPRESA`.
- [ ] Guardados sin `transStart()` / `transComplete()` cuando tocan varias tablas.
- [ ] Acciones sin registro en Centinela (NUEVO / EDITAR / ELIMINAR).
- [ ] Doble envío posible (falta flag `flSubmit` o similar).
- [ ] Campos del formulario que no están en `$allowedFields`.
- [ ] Input del usuario concatenado en SQL.
- [ ] Restos de otro módulo copiado (URLs, títulos, imports).
- [ ] Queries lentas evidentes (sugerir usar la skill `jp-optimizar-query`).

## Formato del informe

```markdown
# Módulo: {nombre}

## Archivos
- Ruta / Menú / Permiso: ...
- Frontend: ...
- Backend: ...
- Tablas: ...

## Flujo por acción
### Listar
botón/evento → endpoint → método → tablas

## Dependencias
- Selects de otros módulos (`getSelect`), helpers, librerías

## Riesgos encontrados
| Severidad | Archivo | Problema | Sugerencia |

## Notas para modificar
- Puntos de extensión y qué no romper
```
