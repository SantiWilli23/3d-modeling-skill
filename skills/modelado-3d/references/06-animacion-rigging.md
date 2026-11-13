# 06 · Animación, shape keys y rigging

## Animación

- Fija `scene.render.fps` **antes** de animar (evita deriva de tiempos).
- Keyframes con `keyframe_insert('location', index=0)` (0=X, 1=Y, 2=Z) si solo animas un eje.
- Rotaciones >180° en Euler se voltean: usa varios keyframes (90/180/270/360) o cuaterniones.
- Bucle: `extrapolation = CYCLIC` o modificador Cycles en la F-curve.
- Interpolación: **Bezier** para lo orgánico (slow-in/slow-out), Linear solo para movimiento constante (orbit, spin).
- **Drivers**: expresiones Python (comprueba que están permitidas en Preferences).
- **NLA**: reutilizar y apilar acciones.

Principios: slow in/slow out · anticipación · follow-through · squash & stretch · arcos naturales.

### Cambio de API en Blender 5.x (importante)

`action.fcurves` / `action.groups` **ya no existen** en 5.0; las acciones usan capas y slots. Accede con `action.layers[].strips[].channelbags[].fcurves` y usa un helper tolerante:

```python
def get_fcurves(action):
    if hasattr(action, "fcurves"):
        return list(action.fcurves)
    out = []
    for layer in action.layers:
        for strip in layer.strips:
            for cb in strip.channelbags:
                out.extend(cb.fcurves)
    return out
```

(Los drivers creados por Python en 5.0 también cambiaron: ya no agregan un modificador de F-curve.)

## Shape keys (morph targets / blendshapes)

1. Crea la *Basis* (pose de reposo).
2. Añade un shape key (`Smile`) y **edita la malla con ese key activo** (entra y sal del Edit Mode para confirmar).
3. Anima `value` 0→1. Para visemes/expresiones, nombres consistentes (`viseme_aa`, `mouthSmile`…).
4. glTF exporta shape keys; Draco **no** los comprime bien → usa Meshopt si hay morph targets.

## Rigging

- Esqueleto humanoide típico: caderas → columna → pecho → cuello → cabeza; brazos/manos; piernas/pies/dedos. Unos ~50 huesos para humanoide básico; 50–100 en juegos; dedos con 2 articulaciones si ahorras.
- **Rigify**: genera el rig de control; los huesos que deforman son `DEF-…` (pesos en `ORG/MCH` se pasan a `DEF`).
- **Pose en T o A**, jerarquía clara, **un único root**, nombres de hueso únicos (Unity Humanoid lo exige).
- **Límite de influencias**: ≤ **4 huesos por vértice** (engines), normaliza pesos y *Limit Total* a 4.
- Weight paint: parte de *Automatic Weights*, corrige codos/rodillas/hombros; *Preserve Volume* en renders, huesos de twist para engines.
- Aplica escala y rotación **antes** de enlazar la armadura al mesh (si no, el rig sale 100× grande o tumbado).
- **Prueba**: importa a la engine, aplica un ciclo de caminar y revisa cada articulación (clipping, colapsos).
- **Mixamo**: sube el FBX sin animar con textura embebida; descarga animaciones "Without Skin" para retargeting.

## Cuándo NO automatizar

Caras humanas, anatomía creíble, visemes finos y piel pintada a mano requieren sculpt manual o modelos base/IA; recomienda el artista o el base mesh en vez de simular con esferas.
