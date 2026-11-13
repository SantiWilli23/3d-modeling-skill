# 01 · Modelado

## Árbol de decisión

- ¿Objeto mecánico / duro? → **hard-surface**: primitivas + Bevel + (Subdivision después) + Boolean + Mirror/Array.
- ¿Orgánico / personaje? → sculpt o base mesh + Subdivision/Multires; retopo después (ver 02).
- ¿Forma a partir de un dibujo o logo? → ver `08` (contornos → malla).
- ¿Repetido a lo largo de un camino (cadena, valla)? → Array + Curve modifier.
- ¿Prueba rápida de composición? → **block-out** con cubos a escala real, sin detalle.

## Medidas reales primero

Nunca adivines proporciones. Antes de modelar un objeto común, usa medidas reales (silla: asiento ~45 cm de alto; puerta ~200×90 cm; espada ~100 cm con hoja ~80 cm; taza ~9 cm). Blender trabaja en metros: comprueba `scene.unit_settings` antes de crear piezas con dimensiones.

## Recetas (patrones)

1. **Primitiva con nombre limpio**: añade, renombra de inmediato (`GEO-…`), fija dimensiones, aplica escala.
2. **Bevel + Subdivision** (hard-surface): Bevel primero (redondea bordes), Subdivision *después*, shade smooth. El orden importa.
3. **Edit mode** (extrude, inset, loop cut): con `bmesh` para geometría; recuerda volcar con `bmesh.update_edit_mesh` / `bm.to_mesh()` o se pierden los cambios.
4. **Boolean** (agujeros/cortes): cortador como objeto aparte → modificador Boolean (Difference) → aplicar → ocultar/borrar cortador. Después limpia: *Merge by Distance*, normales.
5. **Mirror**: modela media pieza, Mirror con *clipping* y *merge*; aplica solo al final.
6. **Array a lo largo de curva**: unidad base + curva + Array (count o fit-to-length) + Curve modifier.
7. **Limpieza tras Boolean o convertir curva→malla**: remove doubles, recalcular normales hacia fuera, eliminar caras internas.

## Críticos (errores típicos)

- **Orientación de objetos alargados**: la cámara debe ver el eje ancho. Una espada vista por el canto parece un palo: rota el objeto, no la cámara.
- **Piezas que se unen**: solapa 5–15 mm. Si solo se tocan, se ve la línea de unión.
- **Punta afilada**: escalar vértices a 0 no basta; colapsa los vértices superiores a la línea central **y** haz *Merge by Distance* para una punta real (si no queda una punta "cortada").
- **Auto smooth**: `Mesh.use_auto_smooth` fue eliminado en Blender 4.1+/5.x. Usa `shade_smooth()` (o el modificador de normales suaves por ángulo).
- **Shared data**: antes de editar un mesh compartido por varios objetos, hazlo *single user*.
- **Modificadores**: déjalos sin aplicar mientras iteras; aplícalos para exportar o bake (o exporta con modificadores aplicados).

## Topología sana (reglas de oro)

- Preferir **quads**; triángulos solo donde la superficie es plana o va a engine.
- Evitar *n-gons* en zonas que se deforman o se subdividen.
- Polos (vértices con ≠4 aristas) lejos de zonas de deformación.
- Edge loops siguiendo la forma y los pliegues (codos, bocas, rodillas).
- Densidad uniforme donde se va a pintar/bakear; más densidad solo donde hay curvatura o silueta importante.
- Mantén simetría cuando sea posible: ahorra trabajo y evita errores de UV.

## Sculpt (resumen)

Flujo: base mesh de pocos polígonos → formas grandes (Grab/Clay Strips/Draw) → medias → detalle fino (Dyntopo o Multires solo al final) → retopología → bake de detalle a normal map. No sculpts detalle fino antes de aprobar la silueta. En 5.x consulta las notas de versión de sculpt si una herramienta falta.
