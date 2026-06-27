# Fase 2: Profundidad y Atmósfera — Plan Detallado

> **Objetivo:** Generación procedural híbrida, biomas por profundidad, sistema de horror, iluminación dinámica, y demo jugable.
> **Duración estimada:** 4-5 meses
> **Pre-requisito:** Fase 1 completa (v0.3.0-alpha)

---

## Resumen de Sub-Fases

| Sub-Fase | Nombre | Tareas | Dependencias |
|----------|--------|--------|--------------|
| **2.A** | Data Layer — Recursos y Configuración | 6 | Ninguna |
| **2.B** | Generación Procedural — MineGenerator | 7 | 2.A |
| **2.C** | Sistema de Biomas — Visuales y Transiciones | 5 | 2.A, 2.B |
| **2.D** | Sistema de Horror — Fases y Atmosfera | 4 | 2.B, 2.C |
| **2.E** | Iluminación Dinámica | 3 | 2.C |
| **2.F** | Partículas y Postprocesado | 2 | 2.C, 2.E |
| **2.G** | Audio Ambiental por Bioma | 2 | 2.C |
| **2.H** | Integración y Demo | 3 | Todo |

**Total: 32 tareas**

---

## 2.A — Data Layer: Recursos y Configuración

> **Objetivo:** Crear los Resources que definen minerales, biomas y loot tables. Todo data-driven para facilitar balance.

### Tarea 2.A.1 — MineralResource (Custom Resource)
**Skill:** `godot-prompter:resource-pattern`

Crear `resources/data/mineral_resource.gd`:
```
class_name MineralResource extends Resource
@export var mineral_id: String
@export var display_name: String
@export var health: int
@export var mining_damage: int
@export var sell_price: int
@export var buy_price: int
@export var rarity: Rarity  # COMMON, UNCOMMON, RARE, VERY_RARE, LEGENDARY
@export var mesh: PackedScene
@export var color: Color
@export var depth_min: int
@export var depth_max: int
@export var spawn_weight: float
@export var battery_drop_chance: float
```

Crear `resources/data/minerals/` con archivos `.tres`:
- `copper.tres` (Common, HP 100, Sell 5, Buy 10, Depth 1-3)
- `iron.tres` (Common, HP 150, Sell 10, Buy 20, Depth 1-3)
- `silver.tres` (Uncommon, HP 175, Sell 25, Buy 50, Depth 4-5)
- `gold.tres` (Rare, HP 200, Sell 50, Buy 100, Depth 6-7)
- `crystal.tres` (Very Rare, HP 300, Sell 100, Buy 200, Depth 4-5, 8-9)
- `cursed_mineral.tres` (Legendary, Depth 10)

**Archivos:** `resources/data/mineral_resource.gd`, `resources/data/minerals/*.tres`
**Validación:** Verificar que cada .tres carga correctamente en Inspector

---

### Tarea 2.A.2 — BiomeResource (Custom Resource)
**Skill:** `godot-prompter:resource-pattern`

Crear `resources/data/biome_resource.gd`:
```
class_name BiomeResource extends Resource
@export var biome_id: String
@export var display_name: String
@export var depth_min: int
@export var depth_max: int
@export var ambient_color: Color
@export var ambient_energy: float
@export var fog_color: Color
@export var fog_density: float
@export var music_track: AudioStream
@export var ambient_sfx: Array[AudioStream]
@export var mineral_table: Array[MineralSpawnEntry]
@export var room_scenes: Array[PackedScene]
@export var tunnel_scene: PackedScene
@export var hazard_chance: float
@export var lighting_preset: LightingPreset
```

Crear `resources/data/biomes/`:
- `surface.tres` (Depth 0, seguro, sin minerales)
- `shallow.tres` (Depth 1-3, Cobre + Hierro, luz ambiental)
- `crystal.tres` (Depth 4-5, Plata + Cristal, bioluminiscencia)
- `abandoned.tres` (Depth 6-7, Oro, antorchas rotas)
- `deep.tres` (Depth 8-9, Cristal + Gema, oscuridad)
- `cursed.tres` (Depth 10, Mineral Maldito, horror)

**Archivos:** `resources/data/biome_resource.gd`, `resources/data/biomes/*.tres`
**Validación:** Verificar que cada bioma carga sus minerales y configs

---

### Tarea 2.A.3 — MineralSpawnEntry (Resource auxiliar)
**Skill:** `godot-prompter:resource-pattern`

Crear `resources/data/mineral_spawn_entry.gd`:
```
class_name MineralSpawnEntry extends Resource
@export var mineral: MineralResource
@export var weight: float  # Peso relativo de spawn
@export var min_count: int
@export var max_count: int
```

Usado dentro de BiomeResource.mineral_table para definir qué minerales spawnan en cada bioma con qué probabilidad.

**Archivos:** `resources/data/mineral_spawn_entry.gd`
**Validación:** Integrar en BiomeResource y verificar Inspector

---

### Tarea 2.A.4 — RoomTemplate (Custom Resource)
**Skill:** `godot-prompter:resource-pattern`

Crear `resources/data/room_template.gd`:
```
class_name RoomTemplate extends Resource
@export var room_id: String
@export var scene: PackedScene
@export var room_type: RoomType  # ENTRANCE, MINERAL, STORY, CHALLENGE, BOSS
@export var biome: BiomeResource
@export var entry_points: Array[Marker3D]  # Conexiones con túneles
@export var min_depth: int
@export var max_depth: int
@export var weight: float  # Probabilidad de selección
```

Crear escenas base para cada tipo de sala (ver 2.A.5).

**Archivos:** `resources/data/room_template.gd`
**Validación:** Verificar que las referencias a escenas son válidas

---

### Tarea 2.A.5 — Crear Room Templates Base (Escenas)
**Skill:** `godot-prompter:scene-organization`

Crear escenas prefabricadas para cada tipo de sala por bioma:

| Tipo | Biomas | Descripción |
|------|--------|-------------|
| `room_entrance.tscn` | Todos | Túnel de entrada, iluminación mínima |
| `room_mineral_shallow.tscn` | Shallow | Cámara con vetas de cobre/hierro |
| `room_mineral_crystal.tscn` | Crystal | Cristales brillantes, plata |
| `room_mineral_abandoned.tscn` | Abandoned | Estructuras rotas, oro |
| `room_mineral_deep.tscn` | Deep | Oscuridad total, gemas raras |
| `room_story.tscn` | Todos | Diario de otro minero, campamento |
| `room_challenge.tscn` | Shallow+ | Plataformas, trampas |
| `room_boss.tscn` | Cursed | Mineral maldito, evento narrativo |

Cada sala tiene:
- `EntryMarker` (Marker3D) en puntos de conexión
- `RoomBody` (StaticBody3D) con mesh de la sala
- `CollisionShape3D` (trimesh)
- `SpawnPoints` (Node3D) vacío para minerales/iluminación
- `LightPoints` (Node3D) vacío para fuentes de luz

**Archivos:** `scenes/rooms/*.tscn`
**Validación:** Cada escena carga sin errores, markers posicionados

---

### Tarea 2.A.6 — Actualizar MineralNode para usar MineralResource
**Skill:** `godot-prompter:resource-pattern`

Modificar `scripts/minerals/mineral_node.gd`:
- Cambiar `@export var mineral_type: String` → `@export var mineral_data: MineralResource`
- Cargar stats desde `mineral_data` en `_ready()` (health, color, etc.)
- Mantener compatibilidad con el sistema actual (fallback si mineral_data es null)
- Actualizar `mineral_node.tscn` para usar el nuevo export

**Archivos:** `scripts/minerals/mineral_node.gd`, `scenes/minerals/mineral_node.tscn`
**Validación:** Mineral existente sigue funcionando, nuevo sistema data-driven funciona

---

## 2.B — Generación Procedural: MineGenerator

> **Objetivo:** Sistema de generación híbrida (rooms prefabricadas + conexiones procedural).

### Tarea 2.B.1 — MineGenerator Core (Autoload)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/autoload/mine_generator.gd`:
```
class_name MineGeneratorClass extends Node

# Configuración
@export var chunk_size: int = 50
@export var render_distance: int = 3
@export var mine_depth: int = 10

# Estado
var current_depth: int = 0
var generated_chunks: Dictionary = {}
var room_queue: Array[RoomTemplate] = []

# Métodos públicos
func generate_chunk(depth: int) -> Node3D
func get_biome_at_depth(depth: int) -> BiomeResource
func get_room_for_depth(depth: int) -> RoomTemplate
func spawn_minerals(room: Node3D, biome: BiomeResource) -> void
func spawn_hazards(room: Node3D, biome: BiomeResource) -> void
func spawn_lighting(room: Node3D, biome: BiomeResource) -> void
```

Registrar como autoload en `project.godot`.

**Archivos:** `scripts/autoload/mine_generator.gd`
**Validación:** Autoload注册成功, generate_chunk() retorna Node3D válido

---

### Tarea 2.B.2 — BiomeSelector (Lógica de Bioma por Profundidad)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/environment/biome_selector.gd`:
```
func get_biome_at_depth(depth: int) -> BiomeResource:
    # Lógica: depth 0 = surface, 1-3 = shallow, 4-5 = crystal, etc.
    # Cargar el .tres correspondiente
    # Retornar fallback a shallow si no se encuentra
```

Integrar con `GameState.change_depth()` para actualizar bioma actual.

**Archivos:** `scripts/environment/biome_selector.gd`
**Validación:** Profundidad 0-10 retorna bioma correcto

---

### Tarea 2.B.3 — RoomSpawner (Colocación de Salas)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/environment/room_spawner.gd`:
```
func spawn_room(template: RoomTemplate, position: Vector3, parent: Node3D) -> Node3D:
    # Instanciar template.scene
    # Posicionar en parent
    # Registrar en generated_chunks
    # Retornar la instancia

func connect_rooms(room_a: Node3D, room_b: Node3D) -> void:
    # Crear túnel entre entry_points
    # Usar tunnel_scene del bioma
```

**Archivos:** `scripts/environment/room_spawner.gd`
**Validación:** Sala se instancia correctamente, túnel conecta dos salas

---

### Tarea 2.B.4 — MineralSpawner (Población de Minerales)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/environment/mineral_spawner.gd`:
```
func spawn_minerals_in_room(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
    # Obtener SpawnPoints de la sala
    # Para cada SpawnPoint, elegir mineral de biome.mineral_table
    # Usar weight para probabilidad
    # Instanciar mineral_node.tscn
    # Configurar con MineralResource
    # Retornar array de minerales spawneados
```

**Archivos:** `scripts/environment/mineral_spawner.gd`
**Validación:** Minerales aparecen en posiciones válidas, tipos correctos por bioma

---

### Tarea 2.B.5 — HazardSpawner (Trampas por Bioma)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/environment/hazard_spawner.gd`:
```
func spawn_hazards_in_room(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
    # Verificar biome.hazard_chance
    # Seleccionar tipo de hazard (spike_trap, falling_rocks, gas_leak)
    # Instanciar hazard.gd con configuración del bioma
    # Retornar array
```

**Archivos:** `scripts/environment/hazard_spawner.gd`
**Validación:** Trampas aparecen según chance del bioma, daño escalado

---

### Tarea 2.B.6 — ChunkManager (Carga/Descarga de Chunks)
**Skill:** `godot-prompter:procedural-generation`

Crear `scripts/environment/chunk_manager.gd`:
```
func _on_player_depth_changed(new_depth: int) -> void:
    # Calcular chunks visibles
    # Generar chunks nuevos
    # Descargar chunks lejanos
    # Mantener memoria bajo control
```

Conectar a `GameState.depth_changed`.

**Archivos:** `scripts/environment/chunk_manager.gd`
**Validación:** Moverse entre profundidades carga/descarga chunks correctamente

---

### Tarea 2.B.7 — Integrar MineGenerator con CaveEntrance
**Skill:** `godot-prompter:procedural-generation`

Modificar `scripts/environment/cave_entrance.gd`:
- Al entrar a la cueva, generar chunk inicial con MineGenerator
- Establecer profundidad inicial = 1
- Conectar señal `depth_changed` a ChunkManager

Modificar `scripts/environment/cave_exit.gd`:
- Al salir, limpiar chunks generados
- Restablecer GameState.current_depth = 0

**Archivos:** `scripts/environment/cave_entrance.gd`, `scripts/environment/cave_exit.gd`
**Validación:** Entrar/salir de cueva genera/destruye chunks correctamente

---

## 2.C — Sistema de Biomas: Visuales y Transiciones

> **Objetivo:** Cada bioma tiene identidad visual, transiciones suaves entre ellos.

### Tarea 2.C.1 — BiomeApplier (Aplicar Visual por Bioma)
**Skill:** `godot-prompter:3d-essentials`

Crear `scripts/environment/biome_applier.gd`:
```
func apply_biome(biome: BiomeResource) -> void:
    # WorldEnvironment: ambient_color, ambient_energy
    # Fog: fog_color, fog_density
    # Sky: cambiar si es necesario
    # Transición tween de 2s entre biomas
```

**Archivos:** `scripts/environment/biome_applier.gd`
**Validación:** Cambio de bioma aplica colores/ Niebla correctamente

---

### Tarea 2.C.2 — BiomeTransitionDetector
**Skill:** `godot-prompter:state-machine`

Crear `scripts/environment/biome_transition_detector.gd`:
```
var current_biome: BiomeResource
var target_biome: BiomeResource

func _on_depth_changed(new_depth: int) -> void:
    target_biome = BiomeSelector.get_biome_at_depth(new_depth)
    if target_biome != current_biome:
        _start_transition()

func _start_transition() -> void:
    # Fade out visual actual
    # Aplicar nuevo bioma
    # Fade in
    # Emitir señal biome_changed
```

**Archivos:** `scripts/environment/biome_transition_detector.gd`
**Validación:** Transiciones son suaves, sin parpadeos

---

### Tarea 2.C.3 — Crear Materiales por Bioma
**Skill:** `godot-prompter:3d-essentials`

Crear materiales base para cada bioma:

| Bioma | Material | Color Tinte | Roughness |
|-------|----------|-------------|-----------|
| Shallow | `mat_shallow.tres` | Marrón claro | 0.7 |
| Crystal | `mat_crystal.tres` | Azul cristal | 0.3 |
| Abandoned | `mat_abandoned.tres` | Gris roto | 0.8 |
| Deep | `mat_deep.tres` | Negro profundo | 0.9 |
| Cursed | `mat_cursed.tres` | Rojo oscuro | 0.5 |

**Archivos:** `resources/materials/biomes/*.tres`
**Validación:** Materiales aplican correctamente a meshes de sala

---

### Tarea 2.C.4 — BiomeDecorations (Props por Bioma)
**Skill:** `godot-prompter:scene-organization`

Crear sistema de decoración por bioma:
- **Shallow:** Cajas de madera, antorchas básicas
- **Crystal:** Cristales suellos, brillo ambiental
- **Abandoned:** Estructuras rotas, herramientas viejas
- **Deep:** Estalactitas, oscuridad
- **Cursed:** Símbolos extraños, luz parpadeante

Usar props existentes en `assets/3d/props/mining/` y `assets/3d/props/furniture/`.

**Archivos:** `scripts/environment/biome_decorations.gd`, `scenes/decorations/*.tscn`
**Validación:** Decoraciones aparecen según bioma, no superpuestas

---

### Tarea 2.C.5 — DepthTracker (Profundidad del Jugador)
**Skill:** `godot-prompter:player-controller`

Modificar `scripts/player/player.gd`:
- Actualizar `GameState.current_depth` basado en posición Y del jugador
- Fórmula: `depth = max(0, int(abs(position.y) / depth_scale))`
- Conectar a `GameState.change_depth()` cuando depth cambie
- Actualizar HUD depth label

**Archivos:** `scripts/player/player.gd`
**Validación:** Profundidad se actualiza al moverse, HUD muestra depth correcto

---

## 2.D — Sistema de Horror: Fases y Atmósfera

> **Objetivo:** Progresión de horror basada en profundidad y tiempo.

### Tarea 2.D.1 — HorrorPhaseManager
**Skill:** `godot-prompter:state-machine`

Crear `scripts/horror/horror_phase_manager.gd`:
```
enum HorrorEvent { NONE, WHISPER, SHADOW, FOOTSTEPS, BREATHING, JUMPSCARE }

var phase: HorrorPhase = HorrorPhase.NONE
var phase_thresholds: Dictionary = {
    HorrorPhase.NONE: 0,       # Depth 0-3
    HorrorPhase.LATENT: 4,     # Depth 4-5
    HorrorPhase.STALKING: 7,   # Depth 7-8
    HorrorPhase.HUNTING: 9     # Depth 9-10
}

func _on_depth_changed(new_depth: int) -> void:
    # Evaluar si cambiar de fase
    # Emitir horror_phase_changed

func trigger_horror_event(event: HorrorEvent) -> void:
    # Ejecutar efecto visual/audio
```

**Archivos:** `scripts/horror/horror_phase_manager.gd`
**Validación:** Fases cambian según profundidad, eventos se ejecutan

---

### Tarea 2.D.2 — HorrorEventSystem (Efectos Visuales)
**Skill:** `godot-prompter:shader-basics`

Crear `scripts/horror/horror_event_system.gd`:
- **WHISPER:** Audio de susurro + ligero screen shake
- **SHADOW:** Sombra rápida en peripheral vision
- **FOOTSTEPS:** Sonidos de pasos cercanos
- **BREATHING:** Sonido de respiración cercana
- **JUMPSCARE:** Flash blanco + sonido fuerte (raro)

**Archivos:** `scripts/horror/horror_event_system.gd`
**Validación:** Cada evento produce efecto correcto, no spamea

---

### Tarea 2.D.3 — HorrorAtmosphere (Ambiente Visual)
**Skill:** `godot-prompter:3d-essentials`

Crear `scripts/horror/horror_atmosphere.gd`:
```
func apply_horror_atmosphere(phase: HorrorPhase) -> void:
    match phase:
        NONE:
            # Normal
        LATENT:
            # Niebla ligera, sonidos distantes
        STALKING:
            # Oscuridad incremental, sonidos cercanos
        HUNTING:
            # Oscuridad total, música intensa
```

**Archivos:** `scripts/horror/horror_atmosphere.gd`
**Validación:** Atmósfera visual/audio escala con fase de horror

---

### Tarea 2.D.4 — Primera Descubierta de Mineral Maldito (Evento Narrativo)
**Skill:** `godot-prompter:dialogue-system`

Crear `scripts/horror/cursed_mineral_event.gd`:
- Detectar primera vez que jugador mina mineral maldito (depth 10)
- Trigger: cambio a HorrorPhase.HUNTING
- Efecto: flashbacks, cambio de música, textura del mineral maldito
- Persistir flag en GameState: `cursed_mineral_discovered`

**Archivos:** `scripts/horror/cursed_mineral_event.gd`
**Validación:** Evento solo se dispara una vez, transición es dramática

---

## 2.E — Iluminación Dinámica

> **Objetivo:** Iluminación diferente por bioma, fuentes de luz colocadas proceduralmente.

### Tarea 2.E.1 — LightingManager (Autoload)
**Skill:** `godot-prompter:3d-essentials`

Crear `scripts/autoload/lighting_manager.gd`:
```
func setup_biome_lighting(biome: BiomeResource) -> void:
    # Configurar WorldEnvironment
    # Ambient light
    # Fog
    # Tonemap

func add_point_light(position: Vector3, color: Color, energy: float, range: float) -> void:
    # Instanciar OmniLight3D
    # Configurar y añadir a escena

func add_torch(position: Vector3) -> void:
    # Antorcha con luz naranja parpadeante
```

Registrar como autoload.

**Archivos:** `scripts/autoload/lighting_manager.gd`
**Validación:** Iluminación aplica por bioma, luces se colocan

---

### Tarea 2.E.2 — TorchSystem (Antorchas Placeables)
**Skill:** `godot-prompter:3d-essentials`

Crear `scripts/environment/torch.gd`:
```
extends Node3D
@export var light_color: Color = Color(1, 0.6, 0.2)
@export var flicker_speed: float = 5.0
@export var flicker_amount: float = 0.2

func _ready():
    # Crear OmniLight3D
    # Crear Particles3D (humo)
    # Iniciar parpadeo

func _process(delta):
    # Parpadeo sinusoidal con ruido
```

Crear `scenes/environment/torch.tscn`.

**Archivos:** `scripts/environment/torch.gd`, `scenes/environment/torch.tscn`
**Validación:** Antorcha parpadea, ilumina área, humo visible

---

### Tarea 2.E.3 — CrystalGlow (Bioluminiscencia)
**Skill:** `godot-prompter:shader-basics`

Crear `scripts/environment/crystal_glow.gd`:
```
extends MeshInstance3D
@export var glow_color: Color = Color(0.3, 0.5, 1.0)
@export var pulse_speed: float = 2.0
@export var pulse_amount: float = 0.3

func _process(delta):
    # Pulso sinusoidal en emission
    # Actualizar material override
```

Integrar con cristales en bioma Crystal.

**Archivos:** `scripts/environment/crystal_glow.gd`
**Validación:** Cristales pulsan con luz suave, efecto bioluminiscente

---

## 2.F — Partículas y Postprocesado

> **Objetivo:** Efectos visuales que refuerzan la atmósfera.

### Tarea 2.F.1 — ParticleEffects (Polvo, Chispas, Cristales)
**Skill:** `godot-prompter:particles-vfx`

Crear efectos de partículas:

| Efecto | Bioma | Nodo | Descripción |
|--------|-------|------|-------------|
| `dust_particles.tscn` | Todos | GPUParticles3D | Partículas de polvo flotando |
| `crystal_sparkle.tscn` | Crystal | GPUParticles3D | Chispas en cristales |
| `torch_smoke.tscn` | Abandoned | GPUParticles3D | Humo de antorchas |
| `mining_sparks.tscn` | Todos | GPUParticles3D | Chispas al minar |
| `cursed_aura.tscn` | Cursed | GPUParticles3D | Aura roja oscura |

**Archivos:** `scenes/particles/*.tscn`
**Validación:** Partículas visibles, rendimiento aceptable

---

### Tarea 2.F.2 — PostProcessing (Bloom, Vignette, Color Grading)
**Skill:** `godot-prompter:shader-basics`

Crear `scripts/ui/post_processing.gd`:
```
func apply_biome_post_processing(biome: BiomeResource) -> void:
    # Ajustar CompositorEffect según bioma
    # Bloom: más en Crystal, menos en Deep
    # Vignette: más en horror phases
    # Color grading: tinte por bioma
```

Crear recursos de Compositor para cada bioma.

**Archivos:** `scripts/ui/post_processing.gd`, `resources/compositor/*.tres`
**Validación:** Postprocesado cambia entre biomas, no impacta rendimiento

---

## 2.G — Audio Ambiental por Bioma

> **Objetivo:** Cada bioma tiene música y SFX únicos.

### Tarea 2.G.1 — BiomeAudioManager
**Skill:** `godot-prompter:audio-system`

Crear `scripts/audio/biome_audio_manager.gd`:
```
func play_biome_music(biome: BiomeResource) -> void:
    # Crossfade entre tracks
    # Fade out actual, fade in nuevo

func play_ambient_sfx(biome: BiomeResource) -> void:
    # Loop de SFX ambiental por bioma
    # Shallow: gotas de agua
    # Crystal: campanas de viento
    # Abandoned: crujidos de madera
    # Deep: respiración lejana
    # Cursed: susurros
```

**Archivos:** `scripts/audio/biome_audio_manager.gd`
**Validación:** Música/SFX cambian con bioma, transiciones suaves

---

### Tarea 2.G.2 — Crear/Asignar Pistas de Audio
**Skill:** `godot-prompter:audio-system`

Organizar audio existente por bioma:

| Bioma | Música | SFX Ambiental |
|-------|--------|---------------|
| Surface | `ambient_piano_01.ogg` | Viento |
| Shallow | `ambient_strings_01.ogg` | Gotas, eco |
| Crystal | `ambient_piano_02.ogg` | Cristales resonando |
| Abandoned | `ambient_strings_02.ogg` | Madera crujiente |
| Deep | `ambient_horror_01.ogg` | Respiración |
| Cursed | `ambient_horror_02.ogg` | Susurros |

**Archivos:** Asignar en BiomeResource.tres
**Validación:** Cada bioma tiene audio asignado, reproduce correctamente

---

## 2.H — Integración y Demo

> **Objetivo:** Todo junto funciona, build para itch.io.

### Tarea 2.H.1 — Integrar Sistema Completo en main.tscn
**Skill:** `godot-prompter:scene-organization`

Reemplazar la cueva estática actual:
- Eliminar minerales hardcodeados de main.tscn
- Conectar CaveEntrance → MineGenerator → ChunkManager
- Verificar flujo completo: Surface → Cave → Profundizar → Biomas → Horror → Volver

**Archivos:** `scenes/main/main.tscn`
**Validación:** Flujo completo funciona de principio a fin

---

### Tarea 2.H.2 — Balance y Tuning
**Skill:** `godot-prompter:godot-optimization`

Ajustar valores después de probar:
- Probabilidad de minerales por bioma
- Daño de trampas por profundidad
- Frecuencia de eventos de horror
- Drain de batería por bioma
- Velocidad de generación de chunks
- Distancia de renderizado

**Archivos:** `resources/data/biomes/*.tres`, `resources/data/minerals/*.tres`
**Validación:** Juego es challenging pero fair, sin bugs de balance

---

### Tarea 2.H.3 — Build para itch.io
**Skill:** `godot-prompter:export-pipeline`

Configurar export:
- Windows (primary)
- Web (HTML5)
- Configurar itch.io project page
- Crear build de demo
- Subir a itch.io

**Archivos:** Configuración de export
**Validación:** Build funciona, no crashea, 30+ FPS estable

---

## Orden de Ejecución Recomendado

```
Semana 1-2:  2.A.1 → 2.A.2 → 2.A.3 → 2.A.4 → 2.A.5 → 2.A.6
Semana 3-4:  2.B.1 → 2.B.2 → 2.B.3 → 2.B.4 → 2.B.5
Semana 5-6:  2.B.6 → 2.B.7 → 2.C.5 → 2.C.1
Semana 7-8:  2.C.2 → 2.C.3 → 2.C.4 → 2.D.1
Semana 9-10: 2.D.2 → 2.D.3 → 2.D.4 → 2.E.1
Semana 11-12: 2.E.2 → 2.E.3 → 2.F.1 → 2.F.2
Semana 13-14: 2.G.1 → 2.G.2 → 2.H.1
Semana 15-16: 2.H.2 → 2.H.3
```

## Validación por Sub-Fase

| Sub-Fase | Criterio de Aceptación |
|----------|----------------------|
| 2.A | Todos los Resources cargan en Inspector, datos correctos |
| 2.B | MineGenerator genera chunks, salas se conectan, minerales spawnean |
| 2.C | Transiciones visuales entre biomas son suaves |
| 2.D | Horror phases cambian según depth, eventos funcionan |
| 2.E | Iluminación varía por bioma, antorchas parpadean |
| 2.F | Partículas visibles, postprocesado no impacta FPS |
| 2.G | Música/SFX cambian por bioma |
| 2.H | Demo completa funciona, build exportable |
