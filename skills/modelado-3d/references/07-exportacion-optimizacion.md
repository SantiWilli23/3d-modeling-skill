# 07 · Exportación y optimización

## ¿Qué formato?

```
Web / Three.js / Babylon / model-viewer ......... glTF / GLB
Motor de juegos (Unity/Unreal/Godot)
  ├─ animado / con rig ........................... FBX (o glTF en motores modernos)
  └─ estático .................................... FBX, OBJ o glTF
AR de Apple ..................................... USDZ
Impresión 3D .................................... STL (sin color) / 3MF (color, multimaterial)
VFX (Maya, Houdini, Nuke) ....................... USD
Ida y vuelta entre DCC .......................... FBX
Destino desconocido ............................. GLB (estándar abierto y universal)
```

## Checklist antes de exportar

1. Aplica **escala y rotación** (y modificadores si el exportador no los aplica).
2. Recalcula normales; revisa que no haya non-manifold.
3. Verifica conteo de tris vs presupuesto.
4. Materiales solo **Principled BSDF + imágenes** (bakea lo procedural).
5. Elimina planos/objetos `REF_` y cortadores ocultos.
6. Exporta y **abre/inspecciona el archivo resultante** (existe, tamaño, tris, texturas).

## Presupuestos de polígonos

Web móvil ≤ 30 k tris · web héroe ≤ 60 k · Unity/Unreal héroe 50–100 k · móvil juego ≤ 10 k · AR/USDZ ≤ 50 k · impresión: sin límite (pero cuida el tamaño de archivo).

## glTF/GLB — optimización para la web

Orden recomendado: **reducir texturas → cuantizar → comprimir geometría → simplificar si hace falta → prune y dedup**.

- Geometría: **Meshopt** es el valor por defecto (decodifica rápido, soporta animación y morph targets). **Draco** comprime algo más pero decodifica más lento y no toca animación/morphs → solo si cada KB cuenta.
- Texturas: **KTX2 (Basis)** para memoria de GPU; WebP/PNG si KTX2 no es viable. 1024–2048 px suele bastar; 512 para props pequeños.
- Simplificar: `gltf-transform simplify in.glb out.glb --ratio 0.5 --error 0.001` (útil en escaneos/CAD).
- Todo en uno: `gltf-transform optimize in.glb out.glb --compress meshopt --texture-compress ktx2`.
- Alternativa más rápida pero menos flexible: `gltfpack`.
- Draco explícito: `gltf-transform draco in.glb out.glb`.
- Objetivo práctico: GLB < 5 MB para web móvil; > 15 MB → decimar y bajar texturas.

### Visor Three.js

Exporta GLB, genera un HTML con `GLTFLoader` (+ `MeshoptDecoder`/`DRACOLoader`/`KTX2Loader` si aplica), `OrbitControls`, luz ambiental/HDRI y auto-rotación. Verifica en el navegador (consola sin errores de decodificador).

## Blender → formatos (headless)

```bash
blender -b -P convert.py -- input.fbx output.glb
```
`--` separa los argumentos de Blender de los del script. Operadores: `bpy.ops.import_scene.fbx/obj/gltf`, `bpy.ops.export_scene.gltf/fbx`, `bpy.ops.wm.obj_export`, `bpy.ops.wm.usd_export`. **Los nombres cambian según la versión**; verifica que existen. La conversión headless pierde materiales con facilidad: valida visualmente.

## Ajustes por formato

- **GLB**: `export_format='GLB'`, animaciones `export_animations=True`, `export_yup=True`, aplica modificadores.
- **FBX**: `embed_textures=True` con `path_mode='COPY'`; ejes `axis_up='Y'`, `axis_forward='-Z'`; `bake_anim=True` para animación; 4 pesos por vértice.
- **OBJ**: nombres ASCII; sin animación.
- **STL**: solo geometría.
- **USD**: pipelines VFX; USDZ para AR (límite de tamaño/tris).
- **Unreal**: colisiones personalizadas con prefijo (`UCX_`, `UBX_`, `USP_`…) = hulls **convexos y cerrados**, misma selección que el mesh; `mesh_smooth_type='FACE'` para grupos de suavizado.

## Problemas típicos

| Síntoma | Arreglo |
|---------|---------|
| FBX sin texturas | `embed_textures=True`, `path_mode='COPY'` |
| Modelo girado 90° en el motor | Ejes de exportación; aplicar rotación |
| Modelo 100× más grande | Aplicar escala; revisar unidad |
| OBJ no importa | Nombres ASCII |
| Animación no exporta | `export_animations=True` / `bake_anim=True` |
| Límite de huesos | ≤4 pesos/vértice y menos huesos |
| FBX con millones de caras | Multires: el nivel de viewport manda al exportar |

## Impresión 3D

Checklist: **unidades en mm** (un modelo en pulgadas sin convertir sale 25.4× más pequeño) → malla **hermética (watertight, manifold)** sin normales invertidas ni autointersecciones → **grosor de pared**: mínimo ~0.8 mm FDM (1.2 mm recomendado en piezas estructurales; 0.8 PLA/PETG, 1.0 ABS/Nylon; valores varían según tecnología) → formato **3MF** (color/multimaterial) o **STL** → resolución suficiente para curvas sin archivos enormes → huecos internos y drenajes para resina → orientación y soportes en el slicer.
