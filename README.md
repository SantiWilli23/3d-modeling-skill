# modelado-3d — skill maestra de modelado y edición 3D para Claude Code

Una sola skill que junta lo mejor de las skills de Blender de la comunidad más investigación sobre edición, limpieza, optimización y exportación de modelos 3D.

## Qué cubre

- Modelado (hard-surface, orgánico, modificadores, medidas reales)
- Limpieza y reparación de mallas, retopología, decimación (escaneos y modelos de IA)
- UV, atlas, bake (normal/AO/curvature), color spaces
- Materiales PBR con valores reales
- Luz, cámara, Cycles/EEVEE, turntables y animaciones de producto
- Animación, shape keys, rigging y skinning
- Exportación y optimización (GLB/Meshopt/KTX2, FBX, USD, STL/3MF), Three.js
- Modelos con IA (Meshy, Tripo, Rodin, TRELLIS, Hunyuan3D) y reconstrucción 1:1 desde imágenes
- `bpy`, MCP de Blender, compatibilidad Blender 4.x ↔ 5.x, modo headless

## Instalación

Windows (PowerShell):

```powershell
./install.ps1
```

macOS / Linux / Git Bash:

```bash
./install.sh
```

Copia `skills/modelado-3d` a `~/.claude/skills/`, la carpeta de skills personales de Claude Code (vale para todas tus sesiones). Reinicia las sesiones abiertas para que la vean.

## Estructura

```
skills/modelado-3d/
  SKILL.md            # índice y reglas generales
  references/01..10   # una referencia por área (se cargan solo si hacen falta)
  references/SOURCES.md
```

## Requisitos opcionales

Blender 4.x/5.x con un MCP (oficial de Blender Lab o `blender-mcp`), `gltf-transform`, Python con `trimesh`/`pymeshlab`, `ffmpeg`, y una API key de Meshy (en variable de entorno) para generar modelos desde fotos.

## Créditos y licencia

Ver `skills/modelado-3d/references/SOURCES.md`. El texto de esta skill es original (resumen y reescritura); los repositorios citados mantienen sus propias licencias. Licencia de este repo: MIT.
