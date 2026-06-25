# Asset Pipeline - Susurros de la Mina

**Versión**: 1.0  
**Última actualización**: 25 de Junio, 2026

---

## Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Flujo de Trabajo](#flujo-de-trabajo)
3. [Formatos de Archivo](#formatos-de-archivo)
4. [Organización de Assets](#organización-de-assets)
5. [Fuentes Recomendadas](#fuentes-recomendadas)
6. [Integración en Godot](#integración-en-godot)
7. [Optimización](#optimización)
8. [Créditos y Licencias](#créditos-y-licencias)

---

## Visión General

### Objetivo

Establecer un flujo de trabajo eficiente y consistente para integrar assets en el proyecto, asegurando:
- Compatibilidad con Godot 4.7
- Rendimiento óptimo
- Organización clara
- Cumplimiento de licencias

### Principios

1. **CC0 primero**: Preferir assets con licencia CC0 (sin atribución requerida)
2. **Formato nativo**: Usar formatos soportados nativamente por Godot
3. **Optimización temprana**: Optimizar assets antes de integrar
4. **Documentación**: Registrar origen y licencia de cada asset

---

## Flujo de Trabajo

### Diagrama de Flujo

```
┌─────────────────┐
│  1. Selección   │  Buscar asset adecuado
│     de Asset    │  Verificar licencia
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  2. Descarga    │  Descargar archivo
│                 │  Verificar integridad
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  3. Conversión  │  Convertir a formato Godot
│                 │  Optimizar si necesario
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  4. Organizar   │  Colocar en carpeta correcta
│                 │  Renombrar si es necesario
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  5. Integrar    │  Importar en Godot
│                 │  Configurar propiedades
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  6. Documentar  │  Registrar en CREDITS.md
│                 │  Actualizar inventario
└─────────────────┘
```

### Checklist por Asset

- [ ] Licencia verificada (preferir CC0)
- [ ] Formato compatible con Godot
- [ ] Resolución/poly count adecuado
- [ ] Colocado en carpeta correcta
- [ ] Importado en Godot sin errores
- [ ] Documentado en CREDITS.md

---

## Formatos de Archivo

### Modelos 3D

| Formato | Soporte | Recomendado | Notas |
|---------|---------|-------------|-------|
| `.glb` | Nativo | ✅ Sí | GlTF Binary, mejor opción |
| `.gltf` | Nativo | ✅ Sí | GlTF con archivos separados |
| `.obj` | Nativo | ⚠️ Limitado | Sin animaciones ni materiales |
| `.fbx` | Import | ⚠️ Limitado | Requiere conversión |
| `.blend` | Import | ⚠️ Limitado | Requiere Blender instalado |

**Recomendación**: Usar `.glb` siempre que sea posible.

### Texturas

| Formato | Soporte | Recomendado | Notas |
|---------|---------|-------------|-------|
| `.png` | Nativo | ✅ Sí | Sin compresión, mejor calidad |
| `.jpg` | Nativo | ⚠️ Limitado | Con compresión, peor para UI |
| `.webp` | Nativo | ⚠️ Limitado | Buena compresión |
| `.tga` | Nativo | ❌ No | No soportado |
| `.bmp` | Nativo | ❌ No | No soportado |

**Recomendación**: Usar `.png` para todo.

**Resoluciones recomendadas**:
- Texturas de modelo: 256x256, 512x512, 1024x1024
- Texturas de UI: Potencias de 2 (16, 32, 64, 128, 256)
- Texturas de entorno: 1024x1024 máximo

### Audio

| Formato | Soporte | Recomendado | Notas |
|---------|---------|-------------|-------|
| `.ogg` | Nativo | ✅ Sí | Mejor para música y loops |
| `.wav` | Nativo | ✅ Sí | Mejor para SFX cortos |
| `.mp3` | Nativo | ⚠️ Limitado | Gap de silencio al loop |
| `.flac` | Nativo | ⚠️ Limitado | Tamaño grande |

**Recomendación**:
- **Música/Ambiente**: `.ogg` (mejor compresión, loop perfecto)
- **SFX cortos**: `.wav` (calidad sin decodificar)
- **Evitar**: `.mp3` (problemas de loop)

### Animaciones

| Formato | Soporte | Recomendado | Notas |
|---------|---------|-------------|-------|
| `.glb` | Nativo | ✅ Sí | Animaciones embebidas |
| `.anim` | Nativo | ✅ Sí | Recurso de Godot |
| `.bvh` | Import | ⚠️ Limitado | Motion capture |

**Recomendación**: Incluir animaciones en el `.glb` del modelo.

---

## Organización de Assets

### Estructura de Carpetas

```
assets/
├── 3d/
│   ├── environment/
│   │   ├── tunnels/           # Secciones de túnel
│   │   ├── rooms/             # Salas completas
│   │   ├── rocks/             # Rocas sueltas
│   │   ├── terrain/           # Suelo, paredes
│   │   └── vegetation/        # Estalactitas, musgo
│   ├── tools/
│   │   ├── pickaxes/          # Diferentes tipos
│   │   ├── lanterns/          # Linternas
│   │   └── accessories/       # Mochilas, etc.
│   ├── minerals/
│   │   ├── ores/              # Vetasy nodos
│   │   ├── crystals/          # Cristales
│   │   └── gems/              # Gemas preciosas
│   ├── props/
│   │   ├── mining/            # Herramientas del entorno
│   │   ├── storage/           # Barriles, cajas
│   │   ├── transport/         # Vagonetas, raíles
│   │   └── furniture/         # Mesas, bancos
│   └── characters/
│       ├── player/            # Modelo del jugador (futuro)
│       ├── npc/               # NPCs
│       └── creatures/         # Criaturas
├── textures/
│   ├── prototype/             # Texturas de prototipo
│   ├── environment/           # Texturas de entorno
│   ├── materials/             # Materiales de Godot
│   └── ui/                    # Texturas de interfaz
├── audio/
│   ├── sfx/
│   │   ├── mining/            # Sonidos de minería
│   │   ├── player/            # Sonidos del jugador
│   │   ├── environment/       # Sonidos ambientales
│   │   ├── ui/                # Sonidos de interfaz
│   │   └── creature/          # Sonidos de criatura
│   ├── music/
│   │   ├── ambient/           # Música ambiental
│   │   ├── tension/           # Música de tensión
│   │   └── horror/            # Música de horror
│   └── voice/
│       ├── whispers/          # Susurros
│       └── effects/           # Efectos de voz
├── animations/
│   ├── player/                # Animaciones del jugador
│   ├── minerals/              # Animaciones de minerales
│   └── creatures/             # Animaciones de criaturas
└── data/
    ├── items/                 # Resource files de items
    ├── minerals/              # Datos de minerales
    └── config/                # Configuraciones
```

### Convenciones de Nombres

#### Modelos 3D

```
{tipo}_{variante}_{versión}.glb

Ejemplos:
pickaxe_basic_v1.glb
tunnel_straight_v1.glb
mineral_copper_large_v1.glb
crystal_blue_cluster_v1.glb
```

#### Texturas

```
{tipo}_{nombre}_{resolución}.png

Ejemplos:
diffuse_rock_512.png
normal_rock_512.png
diffuse_metal_256.png
ui_inventory_bg_256.png
```

#### Audio

```
{tipo}_{nombre}_{variante}.ogg/.wav

Ejemplos:
sfx_pickaxe_hit_rock_01.wav
sfx_pickaxe_hit_rock_02.wav
music_ambient_mine_01.ogg
voice_whisper_distant_01.ogg
```

---

## Fuentes Recomendadas

### Assets 3D (CC0 o CC-BY)

| Fuente | URL | Licencia | Tipo | Costo |
|--------|-----|----------|------|-------|
| Kenney | kenney.nl | CC0 | 3D, Texturas, Audio | Gratis |
| Poly Pizza | poly.pizza | CC0 | Modelos 3D | Gratis |
| OpenGameArt | opengameart.org | Varias | 2D, 3D, Audio | Gratis |
| Sketchfab | sketchfab.com | CC-BY/CC0 | Modelos 3D | Gratis/Pago |
| Quaternius | quaternius.com | CC0 | Modelos 3D | Gratis |

### Assets de Audio (CC0)

| Fuente | URL | Licencia | Tipo | Costo |
|--------|-----|----------|------|-------|
| Kenney Audio | kenney.nl/assets | CC0 | SFX, Música | Gratis |
| OpenGameArt Audio | opengameart.org | Varias | SFX, Música | Gratis |
| Freesound | freesound.org | Varias | SFX | Gratis |
| Pixabay Music | pixabay.com/music | Libre | Música | Gratis |
| Sonniss GDC | sonniss.com/gameaudiogdc | Royalty-Free | SFX | Gratis (anual) |

### Texturas

| Fuente | URL | Licencia | Tipo | Costo |
|--------|-----|----------|------|-------|
| Kenney Textures | kenney.nl | CC0 | Prototipo | Gratis |
| Poly Haven | polyhaven.com | CC0 | PBR | Gratis |
| AmbientCG | ambientcg.com | CC0 | PBR | Gratis |

### Herramientas de Creación

| Herramienta | URL | Uso | Costo |
|-------------|-----|-----|-------|
| Blender | blender.org | Modelado 3D | Gratis |
| GIMP | gimp.org | Edición de texturas | Gratis |
| Audacity | audacityteam.org | Edición de audio | Gratis |
| Bfxr | bfxr.net | Generador de SFX | Gratis |

---

## Integración en Godot

### Importar Modelos 3D

```
1. Arrastrar archivo .glb a la carpeta correspondiente
2. Godot crea automáticamente el recurso importado
3. Configurar en el panel Import:
   - Generate Lightmap UV: Off (para minerales)
   - Generate Tangents: On
   - Force Smooth: On (para low-poly)
4. Crear escena .tscn que use el modelo
```

### Importar Texturas

```
1. Arrastrar archivo .png a la carpeta correspondiente
2. Godot importa automáticamente
3. Configurar en el panel Import:
   - Compression Mode: VRAM Compressed (3D)
   - Mipmaps: On (para 3D)
   - Process: SRGB (para color)
```

### Importar Audio

```
1. Arrastrar archivo .ogg/.wav a la carpeta correspondiente
2. Godot importa automáticamente
3. Configurar en el panel Import:
   - Loop Mode: Forward (para loops)
   - Loop Begin: 0
   - Loop End: -1 (fin del archivo)
```

### Crear Materiales

```gdscript
# Material para mineral
var material = StandardMaterial3D.new()
material.albedo_color = Color(0.8, 0.4, 0.2)  # Cobre
material.metallic = 0.3
material.roughness = 0.7
material.emission_enabled = true
material.emission = Color(0.2, 0.1, 0.0)
material.emission_energy_multiplier = 0.5

# Asignar al mesh
mesh_instance.material_override = material
```

---

## Optimización

### Modelos 3D

| Métrica | Objetivo | Máximo |
|---------|----------|--------|
| Polígonos (props) | 100-500 | 1000 |
| Polígonos (minerales) | 20-100 | 200 |
| Polígonos (entorno) | 200-1000 | 2000 |
| Texturas | 256x256 | 512x512 |
| Materials por mesh | 1 | 2 |

### Texturas

| Métrica | Objetivo | Máximo |
|---------|----------|--------|
| Resolución | 256x256 | 512x512 |
| Compresión | VRAM | DXT |
| Mipmaps | On | On |
| Atlas | Preferir | - |

### Audio

| Métrica | Objetivo | Máximo |
|---------|----------|--------|
| SFX duración | <1s | 3s |
| Música bitrate | 128kbps | 192kbps |
| Sample rate | 44100Hz | 44100Hz |
| Canales | Mono (SFX) | Estéreo (Música) |

### pooling de Objetos

```gdscript
# Object pooling para minerales destruidos
var mineral_pool: Array[MineralNode] = []

func get_mineral() -> MineralNode:
    if mineral_pool.size() > 0:
        var mineral = mineral_pool.pop_back()
        mineral.visible = true
        mineral.set_deferred("monitoring", true)
        return mineral
    return mineral_scene.instantiate()

func return_mineral(mineral: MineralNode) -> void:
    mineral.visible = false
    mineral.set_deferred("monitoring", false)
    mineral_pool.append(mineral)
```

---

## Créditos y Licencias

### Archivo CREDITS.md

Crear `CREDITS.md` en la raíz del proyecto:

```markdown
# Créditos - Susurros de la Mina

## Assets de Terceros

### Texturas de Prototipo
- **Asset**: Kenney Prototype Textures
- **Autor**: Kenney (kenney.nl)
- **Licencia**: CC0 1.0 Universal
- **URL**: https://kenney.nl/assets/prototype-textures
- **Uso**: Texturas de prototipo para testing

### Modelos de Minería
- **Asset**: Free Low Poly Mining Assets
- **Autor**: purepoly
- **Licencia**: CC Attribution 4.0
- **URL**: https://sketchfab.com/3d-models/free-low-poly-mining-assets
- **Uso**: Herramientas, minerales, props

### Modelos de Cuevas
- **Asset**: Modular Caves
- **Autor**: ToxaGrom
- **Licencia**: CC Attribution 4.0
- **URL**: https://sketchfab.com/3d-models/modular-caves
- **Uso**: Estructuras de cueva modulares

### Audio
- **Asset**: Mining Sound Effects
- **Autor**: Various
- **Licencia**: CC0 / CC-BY
- **URL**: https://opengameart.org
- **Uso**: Efectos de sonido de minería
```

### Licencias Comunes

| Licencia | Uso Comercial | Atribución | Modificar | Distribuir |
|----------|---------------|------------|-----------|------------|
| CC0 | ✅ | ❌ | ✅ | ✅ |
| CC-BY | ✅ | ✅ | ✅ | ✅ |
| CC-BY-SA | ✅ | ✅ | ✅ | ✅ (misma licencia) |
| CC-BY-NC | ❌ | ✅ | ✅ | ✅ |
| MIT | ✅ | ❌ | ✅ | ✅ |

---

## Documentación Adicional

- [Game Design](game_design.md) - Documento de diseño
- [Architecture](../technical/architecture.md) - Diseño técnico
- [Coding Standards](../technical/coding_standards.md) - Convenciones