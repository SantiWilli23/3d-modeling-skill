# 09 · Blender Python (bpy), MCP y versiones

## Reglas de ejecución (MCP)

- **Cada llamada es un espacio de nombres nuevo.** Solo `bpy` viene importado; reimporta `math`, `bmesh`, `numpy`.
- **Objetos por nombre**, nunca por variable Python entre llamadas.
- **Trozos pequeños** (~5–20 líneas; ~180 s de timeout). Termina cada trozo reportando qué cambió (nombres, conteos, rutas).
- Comprueba el **estado de la respuesta** del backend, no solo stdout; en el MCP oficial asigna un `result` serializable.
- Prefiere herramientas dedicadas del MCP (resúmenes de escena, capturas, docs) sobre código; el código es el último recurso.
- Prefiere **operadores** (`bpy.ops`) para acciones estándar (manejan contexto) y la **data API** (`bpy.data`) para control fino o sin efectos de contexto.
- Muchos operadores dependen del **modo** y de **objeto activo + selección** (son cosas distintas): fíjalos explícitamente y vuelve a fijarlos entre llamadas.
- En Edit Mode usa **bmesh** y vuelca los cambios.
- Actualiza el depsgraph antes de leer valores calculados (`bpy.context.view_layer.update()`).
- Objetos creados vía `bpy.data` hay que **enlazarlos a una colección**.

## Estructura de la escena

Scene → View Layer → Collections → Objects → datablocks (mesh, material, cámara…). Objeto y datos son entidades separadas; borrar uno no borra el otro. Los datos huérfanos se purgan al guardar. La visibilidad tiene **tres estados** independientes (viewport, view layer, render): si un objeto "desaparece", revisa los tres.

## Esqueleto estándar de una operación

```python
import bpy, math, bmesh
# 1. Alcance: localizar/crear por NOMBRE
obj = bpy.data.objects.get("GEO-ejemplo")
# 2. Trabajo
...
# 3. Reporte
print({"objeto": obj.name if obj else None, "verts": len(obj.data.vertices) if obj else 0})
```

## Compatibilidad entre versiones

| Tema | 4.x | 5.x | Estrategia |
|------|-----|-----|-----------|
| Motor EEVEE | `BLENDER_EEVEE` (≤4.1) / `BLENDER_EEVEE_NEXT` (4.2+) | `BLENDER_EEVEE` | `try/except` con fallback |
| F-curves de Action | `action.fcurves` | capas/slots (`layers[].strips[].channelbags[].fcurves`) | helper tolerante (ver 06) |
| `Mesh.use_auto_smooth` | existe (≤4.0) | eliminado | `shade_smooth()` / normales por ángulo |
| Inputs del Principled | por clave | algunos `enabled=False` | iterar por nombre (ver 04) |
| Drivers por Python | añaden modificador | crean dos keyframes | no asumas el modificador |
| `bpy.props` estilo dict / BGL | existe | eliminado | usar API actual / `gpu` |
| Cycles settings por `scene['cycles']` | funcionaba | restringido | `scene.cycles.<prop>` |

Comprueba al empezar:
```python
import bpy
print(bpy.app.version_string)
print(hasattr(bpy.types.Action, "layers"))
```
Principled BSDF v2 (Coat/Sheen/Subsurface Weight) requiere Blender ≥ 4.0; en 3.x no hay soporte. Verifica contra las notas de versión oficiales: <https://developer.blender.org/docs/release_notes/>.

## Modo headless / lotes

```bash
blender -b archivo.blend -P script.py -- --in a.fbx --out a.glb
```
En el script: `import sys; args = sys.argv[sys.argv.index("--")+1:]`. Sirve para conversiones por lotes, renders sin GUI y CI. Importa/exporta con los operadores de la versión instalada.

## Errores frecuentes

| Error | Causa / arreglo |
|-------|-----------------|
| `'Action' object has no attribute 'fcurves'` | Blender 5.x → helper de capas |
| `BLENDER_EEVEE_NEXT` rechazado | 5.x lo renombró → fallback |
| `KeyError: 'Subsurface IOR'` | input deshabilitado → `set_input` |
| `Cannot render, no camera` | `scene.camera is None` → crear/asignar cámara |
| Objeto no encontrado en la siguiente llamada | usaste variable en vez de `bpy.data.objects[...]` |
| MCP timeout | divide el trabajo en trozos |
| Archivo no está en la ruta esperada | rutas absolutas; verifica con `ls` |
| Viewport gris | está en Solid; cambia a Material Preview |
| "Context is incorrect" en un operador | falta modo/objeto activo/área; usa `temp_override` o la data API |

## Backends MCP

- **Oficial de Blender Lab**: preferido para operaciones comunes; requiere Blender 5.1+, su add-on y un proceso MCP aparte.
- **ahujasid/blender-mcp**: Blender ≥ 4.0; añade descarga de Poly Haven/Sketchfab y generación Hyper3D/Hunyuan. Si la tarea necesita esas herramientas, usa ese backend **desde el inicio** y no cambies a mitad de tarea.
- Los dos pueden coexistir (puertos distintos, entornos Python separados porque ambos instalan un ejecutable `blender-mcp`).
- No cambies la configuración MCP existente del usuario sin permiso.

## Poly Haven

HDRIs, texturas PBR y modelos CC0 desde su API. Útiles para estudio de producto (HDRI + suelo PBR), cambio de materiales (variantes de acabado), escenas con props y aplicar texturas PBR a un objeto.
