---
name: modelado-3d
description: Skill maestra de modelado y edición 3D. Úsala para cualquier pedido de crear, editar, limpiar, optimizar, texturizar, animar, renderizar o exportar modelos 3D (Blender y bpy, glTF/GLB, FBX, OBJ, USD, STL), para modelos generados con IA (Meshy, Tripo, Hunyuan3D, TRELLIS), para reconstruir un modelo desde imágenes o wireframes, y para preparar assets para web, juegos, AR o impresión 3D. Triggers - "modela", "hazme un modelo 3D", "edita este modelo", "retopología", "UV", "bake", "reduce polígonos", "exporta a glb/fbx/stl", "model this", "3D asset", "Blender", "Three.js".
---

# Modelado 3D — skill maestra

Reúne en un solo lugar lo que enseñan las skills de Blender de la comunidad (blender-skills, cc-blender-skill) más investigación propia sobre edición, limpieza y optimización de modelos. Este archivo es el índice: decide la ruta y carga **solo** la referencia que necesites.

## 1. Antes de tocar nada

1. **Define el destino** (web, juego, AR, render, impresión 3D). Todo depende de eso: presupuesto de polígonos, formato, texturas.
2. **Inspecciona lo que ya existe** (escena, objetos, modificadores, materiales, unidades). Nunca asumas valores; no destruyas objetos sin confirmar.
3. **Elige el backend**:
   - Blender abierto con MCP (oficial de Blender Lab, o `ahujasid/blender-mcp`) → ejecuta `bpy` en trozos pequeños.
   - Sin Blender interactivo → `blender -b -P script.py -- args` (headless), o Python puro (`trimesh`, `pymeshlab`) y `gltf-transform` para limpiar/optimizar archivos.
4. Comprueba la versión de Blender (`bpy.app.version_string`). Ver `references/09-blender-python.md` (API cambia entre 4.x y 5.x).

## 2. Mapa de rutas (qué referencia cargar)

| Pedido | Referencia |
|--------|-----------|
| Crear/editar geometría, modificadores, hard-surface, booleanos | `references/01-modelado.md` |
| Malla sucia, escaneo o salida de IA: limpiar, reparar, retopo, decimar | `references/02-limpieza-retopologia.md` |
| UV, atlas, texel density, bake, normal maps | `references/03-uv-texturas-bake.md` |
| Materiales PBR (metal, vidrio, piel, tela…) | `references/04-materiales-pbr.md` |
| Luces, cámara, render (Cycles/EEVEE), turntables | `references/05-luz-camara-render.md` |
| Animación, shape keys, rigging, skinning | `references/06-animacion-rigging.md` |
| Exportar y optimizar (GLB, FBX, USD, STL), polycounts, Three.js | `references/07-exportacion-optimizacion.md` |
| Generar con IA y reconstruir desde imágenes/wireframes | `references/08-ia-y-reconstruccion.md` |
| Errores de `bpy`, versiones, scripts, headless, MCP | `references/09-blender-python.md` |
| Impresión 3D | `references/07-exportacion-optimizacion.md` (sección STL/3MF) |
| Pipeline completo y checklist final | `references/10-pipeline-y-checklists.md` |
| Fuentes y créditos | `references/SOURCES.md` |

## 3. Orden de trabajo (cuando el pedido cruza varias áreas)

1. Referencia + plan → 2. Block-out con primitivas a escala real → 3. Cámara y encuadre → 4. Luz v1 (sin color) → 5. Geometría final → 6. UV → 7. Materiales (valores antes que color) → 8. Luz v2 → 9. Detalle/bake → 10. Render o prueba → 11. Exportar y **verificar el archivo exportado**.

Cada paso bloquea al siguiente: un material afinado con luz plana se ve mal con la luz real.

## 4. Reglas que evitan el 80 % de los fallos

- **Nombra todo**: `GEO-`, `MAT-`, `LGT-`, `CAM-`, `ARM-`, `COL-`. Nunca dejes `Cube.027`.
- **Identifica objetos por nombre** (`bpy.data.objects['GEO-x']`), no por variable de Python: cada llamada MCP es un espacio nuevo.
- **Trozos de 5–20 líneas** (timeout ~180 s por llamada); devuelve datos estructurados.
- **Aplica escala y rotación** (`Ctrl+A`) antes de exportar, modificadores y bake.
- **Metallic es un interruptor**: 0 o 1, no 0.5.
- **Mapas no-color** (roughness, metallic, normal, AO) → espacio de color *Non-Color*.
- **Solapa piezas 5–15 mm** en vez de dejarlas justo tocándose (sin costuras visibles).
- **Verifica siempre**: tras crear, `get_scene_info`/conteo de caras; tras renderizar o exportar, confirma que el archivo existe y su tamaño.
- **Personajes humanos realistas no se logran con primitivas**: usa un base mesh (Poly Haven, Sketchfab CC, IA 3D) y luego edita.
- **Respeta el original**: si el modelo es del usuario o viene de IA, conserva el archivo fuente y trabaja sobre copia (guarda versiones `_v01`, `_v02`).

## 5. Si algo falla

Primero lee el error exacto, arregla esa línea, reintenta. Si es timeout, divide. Si el resultado no se parece a lo pedido, reabre la referencia y compara. Tabla completa de síntomas → causa → arreglo en `references/10-pipeline-y-checklists.md`.
