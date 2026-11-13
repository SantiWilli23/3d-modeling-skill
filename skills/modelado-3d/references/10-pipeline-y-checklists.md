# 10 · Pipeline completo, recuperación y checklists

## Cadena de skills según el pedido

| Pedido | Orden |
|--------|-------|
| "Foto héroe de una espada" | modelado → materiales → luz → cámara → render |
| "Render cinematográfico de esta escena" | cámara → luz → render |
| "Logo 3D para la web" | modelado → materiales → luz → render → exportación |
| "Turntable" | modelado → materiales → cámara → animación → render |
| "Montar un estudio" | cámara → luz (el usuario aporta el modelo) |
| "Modelo de IA a producto pulido" | importar → limpiar (02) → material (04) → estudio (05) → render → exportar (07) |
| "Pipeline completo" | modelado → UV → materiales → luz → cámara → render → exportación |

## Recuperación

| Síntoma | Primera comprobación | Arreglo |
|---------|---------------------|---------|
| Render "plano" | variedad de luz | rim light; más ratio key:fill |
| Muy oscuro | exposición/HDRI | Exposure +0.5 o subir HDRI |
| Muy brillante | view transform | pasar de Standard a AgX |
| Materiales "de plástico" | roughness uniforme | variación procedural |
| Aspecto "de videojuego" | sombras duras + geo afilada | luces Area + bevel a todo |
| Proporciones raras | medidas | releer medidas reales / referencia |
| Render tarda horas | muestras/bounces | 256 + denoise; menos bounces |
| Forma "palo" | eje de cámara | girar el objeto |
| Punta "cortada" | vértices sin fusionar | colapsar + merge by distance |
| Vidrio de color plano | solo base color | Volume Absorption + roughness 0.02–0.05 |
| Textura estirada | UV | checker, re-unwrap, texel density |
| Mapa "al revés" | convención normal | OpenGL vs DirectX, Non-Color |

## Hábitos profesionales

Renombrar al instante · aplicar rotación+escala antes de exportar · usar Colecciones (no padres) para agrupar · guardar versiones incrementales (`_v01`, `_v02`) · empaquetar texturas (`File > External Data > Pack All`) · purgar datos sin uso · comentar scripts.
Menos: sobre-detallar antes de aprobar silueta, afinar materiales con luz plana. Más: referencias, block-out, iterar en pasadas.

## Critique cada cierto tiempo

Compara con la referencia: silueta, proporciones, lectura a distancia, valores (luz/sombra) antes que color, legibilidad en miniatura. Una captura reducida revela errores de lectura.

## Evitar el conformismo (cuando algo "no se puede")

Antes de decir que algo no es posible: ¿hay otra herramienta (Python puro, `gltf-transform`, `trimesh`)? ¿otro backend MCP? ¿un modelo base gratis (Poly Haven, Sketchfab CC, TRELLIS abierto)? ¿puede hacerse headless? Documenta la alternativa elegida.

## Checklist final antes de entregar

- [ ] Destino definido y presupuesto de polígonos cumplido.
- [ ] Nombres limpios (`GEO-/MAT-/…`), sin `Cube.001`.
- [ ] Escala y rotación aplicadas; origen correcto.
- [ ] Malla sana (sin non-manifold, normales hacia fuera).
- [ ] UV sin solapes (si hay bake) y texel density razonable.
- [ ] Materiales: Principled + imágenes; mapas no-color en Non-Color.
- [ ] Exportación realizada y **archivo verificado** (existe, tamaño, tris, texturas, animación).
- [ ] Render/preview revisado en miniatura y a tamaño completo.
- [ ] Licencias de modelos/texturas/IA revisadas.
- [ ] Fuente (`.blend`) guardada con versión.
