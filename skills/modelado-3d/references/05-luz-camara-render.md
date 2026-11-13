# 05 · Luz, cámara y render

## Luz

| Tipo | Uso |
|------|-----|
| **Area** | El 80 % de los casos: ventana, softbox; sombras suaves gratis |
| **Sun** | Luz solar/lunar, rayos paralelos |
| **Point** | Bombillas, velas |
| **Spot** | Focos de escenario, faros |
| **HDRI / World** | Ambiente 360° realista; producto y exteriores |

Decisión por ambiente:
- Estudio/comercial → **tres puntos** (key cálida delante-arriba, fill fría y más débil, rim fría detrás) + HDRI de relleno ~0.3.
- Exterior → Sun + cielo HDRI.
- Interior cinematográfico → Sun por ventana + HDRI bajo + puntos prácticos.
- Dramático/noir → un Spot alto, sin fill.
- Estilizado → tres puntos de alto contraste y key saturada.
- Duda → tres puntos + HDRI (sirve el 90 %).

La energía depende de la distancia (cae con el cuadrado); calibra con un sujeto de ~1 m a ~1.5 m. Ajusta por **ratios** key:fill (p. ej. 2:1 suave, 4:1 dramático), no por números absolutos.

## Cámara

| Focal | Sensación / uso |
|-------|-----------------|
| 14–24 mm | Muy ancho, arquitectura/espectáculo |
| 28–35 mm | Documental, entornos |
| **50 mm** | Neutro (ojo humano) |
| **85 mm** | Retrato, personajes (favorecedor) |
| 100–135 mm | Producto héroe |
| 200 mm+ | Compresión fuerte |

Apertura: f/1.2–2 muy poca profundidad; f/2.8 retrato; f/4 dos sujetos; f/5.6–8 entornos; f/11+ todo nítido. Sensor por defecto 36 mm (full frame).

Composición: regla de tercios (no centrar), aire sobre la cabeza ~10 %, espacio hacia donde mira, tres capas (primer plano/medio/fondo). Retratos humanos ≥ 50 mm para no deformar.

- Pon `dof.focus_object` en el sujeto (si no, enfoca el fondo).
- Usa **Track To** para apuntar; no rotaciones manuales (el orbit se inclina).
- Orbit: empty pivote + cámara hija + rotación Z 0→360° con interpolación **lineal** (velocidad constante).
- Antes de renderizar, asegura que `scene.camera` no es `None`.

## Render

- **Cycles**: fotorrealismo, vidrio, SSS, cáusticas, stills de producto.
- **EEVEE**: previsualización, animación rápida, estilizado.
- Nombre del motor: ≤4.1 `BLENDER_EEVEE`, 4.2 `BLENDER_EEVEE_NEXT`, ≥5.0 `BLENDER_EEVEE` → usa `try/except` con fallback.
- Muestras: exterior directo 64–128 · general 256 · interior con rebote 512 · vidrio/cáusticas/SSS 1024–2048. **Siempre con denoise** (256 + denoise ≈ 4096 crudas).
- Color management: **AgX** (o Filmic); *Standard* quema altas luces.
- Formato: PNG para stills, EXR si vas a componer, MP4 (o secuencia PNG + ffmpeg) para animación.
- Render lento → baja bounces, sube el umbral de ruido, limita subdivisión en render, baja resolución en pruebas.

## Turntable y animaciones de cámara (producto)

- **Turntable 360°**: órbita completa, interpolación lineal; bucle perfecto = primer y último fotograma iguales (no repetir el 361).
- **Push-in/slow zoom**: acerca a un detalle con ease in/out.
- **Dolly + giro**: avance y rotación combinados.
- **Crane**: de bajo a alto para revelar.
- **Loop dinámico**: velocidad variable con barridos rápidos.
Codifica en 24 o 30 fps, `scene.render.fps` **antes** de animar; un MP4 de 5–10 s es suficiente para producto.

## Pulido de producto (GLB importado de IA)

Importar GLB → aplicar escala → material brillante (clearcoat, roughness baja) → estudio con HDRI + tres puntos + suelo con reflejo suave → cámara 85–100 mm → render Cycles + denoise. Comparar HDRIs/materiales en una **rejilla** para elegir variantes.
