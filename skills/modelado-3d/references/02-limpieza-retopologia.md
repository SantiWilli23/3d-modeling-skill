# 02 · Limpieza, reparación, retopología y decimación

Útil para **escaneos, modelos de IA (Meshy/Tripo/TRELLIS…), STL/OBJ descargados** y cualquier malla sucia.

## Orden recomendado (no lo inviertas)

1. **Inspeccionar**: nº de caras/tris, bounding box, unidades, objetos sueltos, ¿watertight?, ¿UV?, ¿materiales?
2. **Quitar basura**: geometría degenerada (caras de área 0), duplicados (vértices/caras), flotantes/islas pequeñas.
3. **Reparar topología**: aristas *non-manifold* (3+ caras en una arista), caras volteadas, agujeros.
4. **Recalcular normales** hacia fuera.
5. **Decimar o rehacer topología** (según el destino).
6. **Re-cerrar agujeros** — la remalla/decimación puede abrir agujeros pequeños.
7. **UV** (se pierden con voxel remesh; re-desenvolver) y **bake** del detalle de la alta a la baja.
8. **Re-verificar** watertight / conteo de polígonos antes de exportar.

## Qué técnica usar

| Caso | Técnica |
|------|---------|
| Orgánico/escaneo → quads limpios | **QuadriFlow** (Remesh) con objetivo de caras |
| Props de fondo, LODs, "solo menos polígonos" | **Decimate** (Collapse); ratio, *Triangulate* si hace falta |
| Hard-surface | Decimate **Planar** (disuelve caras coplanares) o retopo manual |
| Malla muy rota/booleana | **Voxel Remesh** (arregla topología; pierde UV) y luego QuadriFlow/Decimate |
| Control total de flujo de aristas (personajes, animación) | **Retopo manual** (snap a superficie, shrinkwrap) |
| Ratio de poder y archivo en la web | `gltf-transform simplify --ratio 0.5 --error 0.001` |

## Python puro (sin Blender)

- **trimesh**: `mesh.fix_normals()`, `mesh.remove_degenerate_faces()`, `mesh.merge_vertices()`, `mesh.fill_holes()`, `mesh.is_watertight`, `mesh.simplify_quadric_decimation(face_count=N)`.
- **PyMeshLab**: filtros de reparación de non-manifold (`meshing_repair_non_manifold_edges`), eliminación de caras/vértices duplicados y nulos, `meshing_isotropic_explicit_remeshing`, `meshing_decimation_quadric_edge_collapse`, cierre de agujeros.
- **Open3D**: nubes de puntos, reconstrucción (Poisson/BPA) cuando el origen es un escaneo.
- Siempre: **trabaja sobre una copia**; guarda un informe (caras antes/después, watertight sí/no).

## Presupuestos de caras (guía)

Web ≤ 30 k tris (móvil) / ≤ 60 k (héroe escritorio) · Juego móvil ≤ 10 k por asset · Juego PC/consola héroe 50–100 k · AR/USDZ ≤ 50 k. Los LODs: ~50 % de caras por nivel.

## Baked normals tras retopo

La baja no necesita las mismas UV que la alta; la proyección alta→baja las alinea al bakear. Usa cage/extrusión para evitar artefactos y revisa que **las islas no se solapen** (provoca manchas oscuras).

## Comprobaciones finales

- Sin non-manifold ni aristas de 1 cara (salvo que sea malla abierta intencional).
- Normales consistentes (face orientation azul por fuera).
- Escala y rotación aplicadas, origen donde toca (base del objeto).
- Para impresión: grosor mínimo y cerrada (ver 07).
