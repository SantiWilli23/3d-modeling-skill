# 04 · Materiales PBR

Valores de referencia reales: <https://physicallybased.info/> (reflectancia F0 de más de 50 materiales).

## Principios

- **Metallic es un interruptor**: 0 (dieléctrico: plástico, madera, vidrio, piel) o 1 (metal). Valores 0.2–0.8 casi siempre están mal (aspecto "plástico"). Excepción estilística: lentes oscuros ~0.8.
- **Base color de metales claro**: reflejan 30–100 %; mantén ≥ 0.5 sRGB (si no, "metal negro").
- **Roughness 0.01–0.05 mínimo** (0 exacto da artefactos y brillos planos que parecen metal).
- **Variación**: añade ruido/rasguños a roughness o bump; un color plano uniforme se ve falso.
- **Principled BSDF solamente** si el destino es glTF/engine.

## Recetas (puntos de partida)

| Material | Ajustes clave |
|----------|--------------|
| Acero cepillado | Metallic 1, roughness 0.3–0.45 con anisotropía, base gris claro |
| Oro pulido | Metallic 1, roughness ~0.1–0.2, base ≈ (1.0, 0.77, 0.34) |
| Cobre | Metallic 1, roughness 0.2, base ≈ (0.95, 0.64, 0.54) |
| Cromo espejo | Metallic 1, roughness 0.02, base casi blanco |
| Vidrio claro | Transmission 1, roughness 0.0–0.05, IOR 1.45–1.5 |
| Vidrio esmerilado | Transmission 1, roughness 0.2–0.4 |
| Vidrio de color | Superficie casi blanca + **Volume Absorption** (tinte por profundidad); no solo base color |
| Plástico mate | Metallic 0, roughness 0.4–0.6 |
| Barniz / pintura de coche | Coat weight 1, coat roughness bajo |
| Piel | Subsurface (peso ~1, radio ≈ (1.0, 0.25, 0.10)), roughness 0.4–0.5 |
| Tela con sheen (terciopelo) | Sheen weight 0.3–1, roughness 0.6–0.9 |
| Silicona suave | Subsurface leve, roughness 0.4 |
| Emisión (neón, pantalla) | Emission color + strength; quita el BSDF si es 100 % emisivo |
| Madera procedural | Wave (veta) + Noise + ColorRamp → base color y roughness |

## Cuidados por versión

En Blender 5.x algunos inputs del Principled (`Weight`, `Subsurface IOR`) vienen `enabled=False` y fallan por clave (`KeyError`). Usa un helper que **itere** `node.inputs` por nombre en vez de `inputs['Nombre']`.

```python
def set_input(node, name, value):
    for i in node.inputs:
        if i.name == name:
            i.default_value = value
            return True
    return False
```

## Problemas comunes

| Síntoma | Arreglo |
|---------|---------|
| Metal "plástico" | Metallic exactamente 0 o 1 |
| Metal negro | Base color demasiado oscuro |
| Vidrio negro | Sube `transmission_bounces` (24 para vidrio grueso/en capas), Cycles |
| Material no aparece en glTF | Es procedural → bakear a imagen |
| Normal map "al revés" | Imagen en Non-Color; revisa convención OpenGL/DirectX |
| Se ve gris en el viewport | Solid shading ignora materiales: pasa a Material Preview (`shading.type='MATERIAL'`) |
| Se ve plano / sin textura | Añade variación procedural a roughness o bump |

## Reglas de nombre

`MAT-acero_cepillado`, `MAT-vidrio_verde`. Una textura por mapa, nombre `objeto_mapa_resolución` (`silla_normal_2k.png`).
