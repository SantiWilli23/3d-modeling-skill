# 03 · UV, texturas y bake

## Reglas innegociables

1. Una textura de imagen necesita un **material con nodos** que la use; ver UVs en el viewport no basta.
2. **Albedo/base color = sRGB.** Roughness, metallic, bump, normal, AO, lightmap = **Non-Color**.
3. Un atlas se mapea **por región** (cada parte a su rectángulo). Nunca apliques el atlas completo a cada pieza.
4. Decals con alpha: material en `BLEND`/`Alpha Hashed`/`Alpha Clip` y PNG correcto; sin "planos negros".
5. Para GLB, mantente en nodos que el exportador entiende: **Principled BSDF + Image Texture + UV + normal map**. Lo procedural se **bakea a imagen** antes de exportar.
6. Valida con una **textura de cuadrícula (checker)** antes de afinar el material.

## Desenvolver (unwrap)

- Costuras donde no se vean (bajo el objeto, pliegues, bordes duros). **Cada borde duro debe ser costura** si va a engine con normal map.
- Método: *Angle Based* (mejores ángulos), *Conformal* (mantiene forma), *Minimum Stretch* (densidad más pareja); para hard-surface, *Smart UV Project* o costuras manuales + *Pack Islands*.
- **Texel density uniforme**: islas proporcionales a su tamaño real en el objeto (salvo zonas importantes que merecen más).
- **Sin solapes** para bake; **todo dentro de 0–1** (salvo UDIM/tileables intencionales).
- **Margen/padding** acorde a la resolución: ~4–8 px a 1k, 8–16 px a 2k, 16–32 px a 4k.
- Re-revisa costuras tras retopología (marcas antiguas pueden quedar).

## Cobertura de superficies cerradas/extruidas

Si un objeto es una placa extruida (logo, mascota), tapas frontal/trasera y paredes laterales necesitan **tratamiento UV propio**: proyección frontal para las tapas, UV lateral o color bakeado para los lados. No dependas de planos proyectados parciales ni de "líneas" superpuestas; el giro (turntable) delata los costados lisos.

## Bake (alta → baja)

Mapas típicos: **Normal**, **AO**, **Curvature**, **Albedo/color**, **Roughness/Metallic** (si el origen es procedural), **Emission**.

1. Baja y alta alineadas (misma posición/escala; aplica transforms).
2. Baja con UV limpias y sin solapes; alta con detalle.
3. Cage (o extrusión + distancia máxima de rayo) para evitar artefactos.
4. Imagen destino creada y **seleccionada** en el nodo de textura del material de la baja.
5. Normal: Tangent space, `+Y` (OpenGL) para Blender/Unity/glTF; DirectX (`-Y`) para Unreal → invierte el canal verde si hace falta.
6. Bake → guardar imagen → **reconectar** y verificar.
7. Multires: baja al nivel 0 **antes** de bakear (no solo antes de exportar), y deja Multires como último modificador.

## Atlas y reconstrucción fiel

Si el usuario aporta un atlas o decals de marca y exige 1:1: detecta regiones del atlas, mapea cada parte a su rectángulo, ajusta la geometría a los contornos de la textura (no estires la textura sobre una malla aproximada) y valida con un overlay frente a la referencia. Detalle del flujo en `08`.

## Checklist de validación

- [ ] Hay capa UV y está activa.
- [ ] El checker no muestra estiramiento visible en zonas principales.
- [ ] Rectángulos de atlas por pieza, no atlas entero en todas.
- [ ] Roughness/normal/AO/bump en Non-Color.
- [ ] Alpha con blend mode y sin plano negro de respaldo.
- [ ] El GLB incluye las imágenes esperadas y excluye planos de referencia (`REF_`).
- [ ] Un render frontal con overlay confirma la alineación con la plantilla.
