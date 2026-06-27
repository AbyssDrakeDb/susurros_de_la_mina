# Fase 3: Despertar del Horror — Plan Detallado

> **Objetivo:** Implementar la criatura con IA, mecánicas de evasión, narrativa ambiental, y progresión de horror.
> **Duración estimada:** 4-5 meses
> **Estado:** 🔲 PENDIENTE (0/8 tareas)
> **Dependencias:** Fase 2 completa (biomas, iluminación, audio ambiental)

---

## Resumen

La Fase 3 transforma el juego de minería en survival horror. Una criatura con IA de patrulla/ persecución / búsqueda acecha al jugador en profundidades avanzadas. El jugador debe esconderse, distrayr, y sobrevivir mientras descubre la narrativa a través de notas y grabaciones. El horror escala gradualmente desde señales sutiles hasta persecuciones activas.

---

## Sub-Fases

| Sub-Fase | Nombre | Tareas | Dependencias |
|----------|--------|--------|--------------|
| **3.A** | IA de Criatura | 3 | Fase 2.D (HorrorPhaseManager) |
| **3.B** | Mecánicas de Evasión | 2 | 3.A |
| **3.C** | Narrativa y Ambiental | 2 | 2.C (Biomas) |
| **3.D** | Integración y Balance | 1 | Todo |

---

## 3.A — IA de Criatura

> **Objetivo:** Criatura con 3 estados: Patrol, Chase, Search. Detección por ruido y luz.

### Tarea 3.A.1 — CreatureAI (Autoload o Node)
**Skill:** `godot-prompter:ai-navigation`

Crear `scripts/horror/creature_ai.gd`:
```
extends CharacterBody3D
class_name CreatureAI

enum State { IDLE, PATROL, CHASE, SEARCH, RETREAT }

var current_state: State = State.IDLE
var target: Player = null
var patrol_points: Array[Vector3] = []
var last_known_position: Vector3 = Vector3.ZERO
var detection_range: float = 15.0
var chase_speed: float = 7.0
var patrol_speed: float = 3.0

# Detección
var hearing_sensitivity: float = 1.0
var vision_angle: float = 120.0
var vision_range: float = 20.0

func _physics_process(delta: float) -> void:
    match current_state:
        State.PATROL: _patrol(delta)
        State.CHASE: _chase(delta)
        State.SEARCH: _search(delta)
        State.RETREAT: _retreat(delta)

func _on_noise_heard(position: Vector3, volume: float) -> void:
    if volume * hearing_sensitivity > threshold:
        last_known_position = position
        change_state(State.SEARCH)

func _on_player_spotted(player_pos: Vector3) -> void:
    target = player
    change_state(State.CHASE)

func change_state(new_state: State) -> void:
    # Transiciones con lógica específica
```

**Archivos:** `scripts/horror/creature_ai.gd`
**Validación:** Criatura patrulla entre puntos, detecta jugador, cambia de estado

---

### Tarea 3.A.2 — Detección de Ruido
**Skill:** `godot-prompter:audio-system`

Crear `scripts/horror/noise_detector.gd`:
```
extends Node3D

# Fuentes de ruido del jugador:
# - Pasos: volumen bajo, alcance corto
# - Minado: volumen alto, alcance medio
# - Correr: volumen medio, alcance corto
# - Romper cosas: volumen muy alto, alcance largo

func emit_noise(position: Vector3, noise_type: NoiseType, intensity: float) -> void:
    # Notificar a CreatureAI si está en rango
    # Mostrar indicador visual de sonido
```

Integrar con `player.gd`:
- Pasos → `emit_noise()` cada paso
- Minado → `emit_noise()` al golpear mineral
- Sprint → `emit_noise()` con volumen reducido

**Archivos:** `scripts/horror/noise_detector.gd`, modificar `scripts/player/player.gd`
**Validación:** Criatura reacciona a ruido del jugador, diferentes volúmenes

---

### Tarea 3.A.3 — Detección de Luz
**Skill:** `godot-prompter:3d-essentials`

Crear `scripts/horror/light_detector.gd`:
```
extends Node3D

# La criatura detecta:
# - Linterna del jugador (si apunta hacia ella)
# - Antorchas encendidas (evita zonas iluminadas)
# - Cristales brillantes (zona segura temporal)

func is_in_light(position: Vector3) -> bool:
    # Raycast hacia fuentes de luz
    # Retornar true si posición está iluminada

func get_dark_path(from: Vector3, to: Vector3) -> PackedVector3Array:
    # Encontrar camino evitando zonas iluminadas
```

Integrar con sistema de iluminación de Fase 2.

**Archivos:** `scripts/horror/light_detector.gd`
**Validación:** Criatura evita zonas iluminadas, usa oscuridad para acercarse

---

## 3.B — Mecánicas de Evasión

> **Objetivo:** El jugador tiene herramientas para sobrevivir: esconderse, distrayr, correr.

### Tarea 3.B.1 — Sistema de Escondites
**Skill:** `godot-prompter:state-machine`

Crear `scripts/horror/hiding_spot.gd`:
```
extends Area3D

@export var hiding_type: HidingType  # WARDROBE, CRACK, DARK_ZONE
var is_occupied: bool = false

func _on_player_interact() -> void:
    if not is_occupied:
        player.enter_hiding_spot(self)

func hide_player(player: Player) -> void:
    # Ocultar modelo del jugador
    # Desactivar detección por vista
    # Criatura no puede ver al jugador
    #限制 tiempo de permanencia

func reveal_player(player: Player) -> void:
    # Restaurar modelo
    # Reactivar detección
```

Crear escenas prefabricadas:
- `hiding_wardrobe.tscn` — Armario (bioma Abandoned)
- `hiding_crack.tscn` — Grieta en pared (todos los biomas)
- `hiding_dark_zone.tscn` — Zona oscura (bioma Deep)

**Archivos:** `scripts/horror/hiding_spot.gd`, `scenes/horror/hiding_*.tscn`
**Validación:** Jugador puede esconderse, criatura pierde跟踪, tiempo limitado

---

### Tarea 3.B.2 — Sistema de Distracciones
**Skill:** `godot-prompter:component-system`

Crear `scripts/horror/distraction.gd`:
```
extends Node3D

@export var distraction_type: DistractionType  # ROCK, LIGHT_BOMB, NOISEMAKER
@export var duration: float = 5.0
@export var range: float = 20.0

func activate() -> void:
    # Crear fuente de ruido/luz falsa
    # Atraer criatura hacia la posición
    # Después de duration, desactivar
```

Items disponibles en tienda:
- **Piedra:** Lanza piedra que crea ruido (20g)
- **Bomba de luz:** Flash temporal que asusta a criatura (50g)
- **Ruidoso:** Aparato que crea ruido constante (30g)

**Archivos:** `scripts/horror/distraction.gd`, agregar a ShopPanel
**Validación:** Distracciones atraen criatura, duración correcta

---

## 3.C — Narrativa y Ambiental

> **Objetivo:** Contar la historia a través del ambiente, notas, y eventos.

### Tarea 3.C.1 — Sistema de Notas/Diarios
**Skill:** `godot-prompter:dialogue-system`

Crear `scripts/horror/note.gd`:
```
extends Area3D

@export var note_id: String
@export var title: String
@export var content: String
@export var audio_playback: AudioStream  # Opcional: nota de audio

func _on_player_interact() -> void:
    # Mostrar UI de nota
    # Reproducir audio si existe
    # Marcar como leída en GameState
    # Desbloquear achievement si aplica
```

Crear `scenes/ui/note_reader.tscn`:
- Fondo semi-transparente
- Título + contenido con scroll
- Botón cerrar
- Indicador de "nueva nota"

Notas por bioma (ejemplos):
- **Shallow:** "Diario del minero principiante"
- **Crystal:** "Notas de la expedición geológica"
- **Abandoned:** "Último registro del supervisor"
- **Deep:** "Grabación distorsionada"
- **Cursed:** "El despertar"

**Archivos:** `scripts/horror/note.gd`, `scenes/ui/note_reader.tscn`, `scenes/horror/note*.tscn`
**Validación:** Notas legibles, audio reproduce, GameState registra

---

### Tarea 3.C.2 — Horror Progresivo (Eventos Ambientales)
**Skill:** `godot-prompter:particles-vfx`

Crear `scripts/horror/ambient_horror.gd`:
```
extends Node

# Eventos por fase de horror:
# LATENT: Sombras en peripheral, sonidos distantes
# STALKING: Objetos se mueven, luces parpadean, pasos cercanos
# HUNTING: Todo intensificado, jump scares raros, physically manifested

func trigger_ambient_event(phase: HorrorPhase) -> void:
    match phase:
        HorrorPhase.LATENT:
            # 10% chance cada 30s: susurro suave
            # 5% chance cada 60s: sombra rápida
        HorrorPhase.STALKING:
            # 20% chance cada 20s: objeto se mueve
            # 15% chance cada 30s: luz parpadea
            # 10% chance cada 45s: pasos cercanos
        HorrorPhase.HUNTING:
            # 30% chance cada 15s: cualquiera de los anteriores
            # 5% chance cada 120s: jump scare
```

**Archivos:** `scripts/horror/ambient_horror.gd`
**Validación:** Eventos escalan con fase, no spamean, son吓人 pero no irritantes

---

## 3.D — Integración y Balance

> **Objetivo:** Todo junto funciona, la dificultad es challenging pero fair.

### Tarea 3.D.1 — Balance de Criatura y Dificultad
**Skill:** `godot-prompter:godot-optimization`

Ajustar parámetros post-testing:
- Velocidad de criatura vs jugador
- Rangos de detección (ruido, luz, vista)
- Tiempo de persecución antes de retreat
- Cooldown de habilidades de criatura
- Frecuencia de eventos ambientales
- Efectividad de distracciones
- Tiempo de escondite

**Archivos:** `scripts/horror/creature_ai.gd`, `scripts/horror/noise_detector.gd`
**Validación:** Juego es challenging pero no frustrante, criatura es amenazante pero evadible

---

## Archivos a Crear en Fase 3

| Archivo | Líneas estimadas | Descripción |
|---------|-------------------|-------------|
| `scripts/horror/creature_ai.gd` | ~300 | IA de criatura con 5 estados |
| `scripts/horror/noise_detector.gd` | ~80 | Detección de ruido del jugador |
| `scripts/horror/light_detector.gd` | ~60 | Detección de zonas iluminadas |
| `scripts/horror/hiding_spot.gd` | ~100 | Sistema de escondites |
| `scripts/horror/distraction.gd` | ~80 | Sistema de distracciones |
| `scripts/horror/note.gd` | ~60 | Notas/diarios legibles |
| `scripts/horror/ambient_horror.gd` | ~120 | Eventos ambientales por fase |
| `scenes/horror/creature.tscn` | ~80 | Escena de criatura |
| `scenes/horror/hiding_*.tscn` | ~60 c/u | 3 tipos de escondites |
| `scenes/horror/note_*.tscn` | ~40 c/u | 10+ notas distribuidas |
| `scenes/ui/note_reader.tscn` | ~100 | UI de lectura de notas |
| **TOTAL** | **~1,200** | |

---

## Orden de Ejecución Recomendado

```
Semana 1-2:  3.A.1 (CreatureAI core)
Semana 3-4:  3.A.2 (Detección ruido) + 3.A.3 (Detección luz)
Semana 5-6:  3.B.1 (Escondites) + 3.B.2 (Distracciones)
Semana 7-8:  3.C.1 (Notas/diarios) + 3.C.2 (Horror ambiental)
Semana 9-10: 3.D.1 (Balance y tuning)
```

---

## Validación por Sub-Fase

| Sub-Fase | Criterio de Aceptación |
|----------|----------------------|
| 3.A | Criatura patrulla, detecta jugador, persigue y busca |
| 3.B | Jugador puede esconderse y distrayr, criatura reacciona |
| 3.C | Historia se cuenta a través de notas, eventos ambientales escalan |
| 3.D | Dificultad balanceada, sin bugs críticos, 30+ FPS |

---

## Integración con Fases Anteriores

| Sistema Fase 2 | Uso en Fase 3 |
|-----------------|---------------|
| HorrorPhaseManager | Define cuándo aparece criatura |
| HorrorEventSystem | Eventos de ruido/luz para criatura |
| BiomeApplier | Criatura usa información de bioma |
| LightingManager | Detección de luz de criatura |
| BiomeAudioManager | Audio de criatura por bioma |
| ChunkManager | Criatura solo en chunks cargados |
