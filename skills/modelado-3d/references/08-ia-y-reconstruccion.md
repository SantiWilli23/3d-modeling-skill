# 08 · Modelos generados con IA y reconstrucción desde imágenes

## Generadores de 3D con IA (panorama; verifica versiones y licencias vigentes)

| Herramienta | Notas |
|-------------|-------|
| **Meshy** (API) | texto/imagen → 3D; modo low-poly; plan gratis con restricciones de licencia (revisa) |
| **Tripo** | bueno para pipelines de juegos: auto-rig, quad remesh, UV/textura/export |
| **Rodin (Hyper3D)** | muy buen resultado "listo para producción" en comparativas |
| **TRELLIS.2** (Microsoft) | abierto, ejecutable en local, licencia MIT |
| **Hunyuan3D** | pesos abiertos 2.x con licencia comunitaria (con exclusiones regionales); motores más nuevos solo hospedados |

Licencias: los planes gratuitos pueden publicar tu modelo bajo CC o prohibir uso comercial. **Lee los términos antes de usar un modelo en un producto.**

### Flujo recomendado con una foto (Meshy)

1. Una foto limpia (objeto aislado, fondo liso) → `POST` a la API de imagen-a-3D → consulta la tarea hasta `SUCCEEDED` → descarga el `.glb`.
2. Varias fotos (1–4 ángulos) del mismo objeto → endpoint multi-imagen: más precisión.
3. Importar el GLB a Blender (MCP o headless), aplicar escala, revisar.
4. **Limpiar y retopologizar** (ver 02), re-UV si hace falta, **pulir** materiales (ver 04, 05).
5. Exportar optimizado (ver 07).

La API key va en una **variable de entorno**, nunca en el repo. Las rutas de salida deben ser configurables (no copies rutas de otro usuario).

### Reglas con salidas de IA

- Suelen traer **mucha geometría y topología triangulada** → decima o retopologiza.
- Texturas con iluminación "horneada": desatúrala o rehaz el albedo si va a ir bajo luz dinámica.
- Revisa non-manifold, islas flotantes y escala (puede venir en unidades arbitrarias).
- **Conserva los modelos originales sin reducir** cuando el usuario lo pida; trabaja en copias (p. ej. integrar al final, sin recortar polígonos si se pidió así).

## Reconstrucción fiel (1:1) desde plantillas, wireframes o atlas

Úsala cuando el modelo **debe coincidir** con una referencia (mascota, logo, hoja de personaje, dibujo ortográfico) y no vale "algo parecido".

### Jerarquía de la verdad

1. Plantilla frontal / wireframe frontal: silueta, nº de partes visibles, lectura de marca.
2. Atlas de textura: formas exactas de piezas, límites de color, decals.
3. Vistas lateral/trasera/superior: profundidad y grosor (no cambian la proyección frontal).
4. Feedback del usuario: restricciones duras → conviértelas en puertas de validación.

### Pipeline

1. **Inventario** de fuentes (front, side, back, top, atlas, decals, mapas).
2. **Análisis local** de imágenes (OpenCV/NumPy/SciPy/Pillow): contornos, área, bbox, centroides.
3. **Segmentar partes** que se solapan antes de mallar.
4. **Fijar la referencia frontal** en Blender (plano o Image Empty `REF_`, excluido de la exportación).
5. **Registrar vistas** en un sistema de coordenadas común: frente = X/Z, lateral = Y/Z, superior = X/Y; la trasera valida, no manda.
6. **Contorno → malla**: genera la superficie directo desde el contorno 2D (quad strip/grid), no con primitivas aproximadas; añade profundidad **después** de bloquear la silueta.
7. **UV y atlas** por región (ver 03); ajusta la malla a los contornos de la textura.
8. **Validar** con máscaras: IoU frontal por encima del umbral, nº de partes exacto, centroides de rasgos dentro de tolerancia, previews frontal/lateral/trasera/superior y overlay.
9. **Reparar con landmarks** (puntas, esquinas, ojos, sonrisa, aura) cuando IoU no basta.
10. **Bucle comparar-ajustar** hasta pasar todas las vistas; **no exportes si falla una puerta**.

Si las vistas se contradicen, mantén la lectura frontal de marca, documenta el conflicto y avisa al usuario.

### De wireframe a 3D

Entrada: PNG ortográficos (frente/lado/trasera). Analizador → puntos de control (px→mm) → código Blender → validar → GLB. Necesita `opencv-python`, `numpy`, `scipy`. Límite: da una forma estructural, no un personaje detallado.

### Animación sobre reconstrucciones

Transiciones entre estados de textura sin fundidos feos de imagen entera; halos/HUD orbitales derivados de la fuente, discretos; valida con *contact sheet* (hoja de contactos), estabilidad de silueta, parpadeos y encuadre antes de aceptar.

## Calibrar el aspecto contra una referencia

Mide color, brillo, saturación, bbox y máscara de render vs referencia; ajusta material, luz, recorte de cámara y emisión hasta que los números coincidan (si dice "muy brillante", "desaturado", "tono equivocado": medir, no adivinar).
