---
name: jp-replicar-flujo
description: Replica un flujo o módulo existente (CRUD, modal, reporte, proceso) hacia una nueva entidad respetando las convenciones del proyecto (CodeIgniter 4 + vistas JS vanilla). Usar cuando el usuario pida crear un módulo "igual a", copiar, clonar o replicar un flujo, o generar un CRUD nuevo a partir de uno de referencia.
---

# Replicar flujo

## Entradas necesarias

Antes de empezar, confirmar (preguntar si falta):

- **Módulo origen** (ej. `motivoTraslado`).
- **Entidad destino** y su tabla en BD.
- **Campos** del formulario y del listado.
- Si el valor que guardan otros módulos es el **id** o el **código** (afecta `getSelect`).

## Tabla de nombres

Derivar todos los nombres antes de crear archivos:

| Capa | Patrón | Ejemplo |
|------|--------|---------|
| Tabla BD | `snake_case` | `motivo_traslado` |
| Modelo | `{Pascal}Model.php` | `MotivoTrasladoModel.php` |
| Controladores | `Controllers/{Grupo}/{Pascal}/` | `MotivoTraslado/` |
| Vista | `views/{grupo}/{camelCase}/` | `motivoTraslado/` |
| Permiso / ruta / sidebar | `kebab-case` | `configuracion-motivo-traslado` |
| API | `{grupo}/{Pascal}/{Pascal}Controller` | `MotivoTraslado/MotivoTrasladoController` |

## Flujo

1. **Leer el origen completo** (backend, frontend, integración) antes de copiar.
2. **Copiar** carpetas de controladores y vista renombrando archivos y carpetas (`modal{Pascal}/`, `modalDelete{Pascal}/`).
3. **Reemplazar** clases, namespaces, imports, URLs `BASE_API`, títulos, permisos y textos de Centinela.
4. **Ajustar modelo**: `$table`, `$allowedFields`, timestamps, `id_empresa`.
5. **Ajustar queries** de `Listar` / `Guardar` / `Eliminar` a las columnas nuevas, manteniendo filtro `ID_EMPRESA` y transacciones.
6. **Ajustar UI**: columnas del DataTable, inputs del modal (`name` = columnas BD).
7. **Integrar** en los 3 archivos: rutas (`app/routes/*.js`), `Menu_sidebar.js`, `Rol.js`.
8. **Validar** con la checklist.

## Checklist de cierre

- [ ] `grep` del nombre del módulo origen no devuelve restos en los archivos nuevos.
- [ ] Endpoints: `index`, `getEdit`, `getSelect`, `save`, `delete`.
- [ ] Permisos `new` / `edit` / `delete` con el menú correcto.
- [ ] Filtro `ID_EMPRESA` en listar, editar y eliminar.
- [ ] Centinela en NUEVO / EDITAR / ELIMINAR.
- [ ] `php -l` sin errores en todos los PHP nuevos.
- [ ] Ruta, sidebar y rol registrados con el mismo `kebab-case`.
- [ ] No se modificaron archivos ajenos al módulo.
