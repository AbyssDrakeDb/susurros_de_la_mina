# Arquitectura Técnica - Susurros de la Mina

**Versión**: 1.0  
**Última actualización**: 25 de Junio, 2026  
**Motor**: Godot 4.7

---

## Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Sistemas Principales](#sistemas-principales)
3. [Autoloads](#autoloads)
4. [Sistema de Jugador](#sistema-de-jugador)
5. [Sistema de Minería](#sistema-de-minería)
6. [Sistema de Inventario](#sistema-de-inventario)
7. [Sistema de Entorno](#sistema-de-entorno)
8. [Sistema de Audio](#sistema-de-audio)
9. [Sistema de UI](#sistema-de-ui)
10. [Guardado y Carga](#guardado-y-carga)
11. [Generación Procedural](#generación-procedural)
12. [Sistema de Horror](#sistema-de-horror)

---

## Visión General

### Filosofía de Diseño

La arquitectura de Susurros de la Mina sigue estos principios:

1. **Separación de Responsabilidades**: Cada sistema maneja un aspecto único del juego
2. **Comunicación por Señales**: Los sistemas se comunican principalmente mediante señales de Godot
3. **Composición sobre Herencia**: Preferir nodos compuestos sobre jerarquías profundas
4. **Datos sobre Código**: Configurar comportamientos mediante recursos cuando sea posible

### Diagrama de Sistemas

```
┌─────────────────────────────────────────────────────────────────────┐
│                         GAME LOOP PRINCIPAL                        │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐    ┌───────────────────┐    ┌───────────────────┐
│ PLAYER SYSTEM │    │ ENVIRONMENT SYSTEM│    │    UI SYSTEM      │
│               │    │                   │    │                   │
│ • Camera      │    │ • World           │    │ • HUD             │
│ • Movement    │    │ • Lighting        │    │ • Menus           │
│ • Input       │    │ • Physics         │    │ • Inventory UI    │
│ • Flashlight  │    │ • Chunks          │    │ • Dialog          │
└───────┬───────┘    └─────────┬─────────┘    └─────────┬─────────┘
        │                      │                        │
        │         ┌────────────┴────────────┐           │
        │         │                         │           │
        ▼         ▼                         ▼           ▼
┌───────────────────────────────────────────────────────────────────┐
│                      GAME STATE (Autoload)                        │
│                                                                   │
│  • Game Phase    • Inventory Data    • Progression Flags          │
│  • Player Stats  • Quest State       • Settings                   │
└───────────────────────────┬───────────────────────────────────────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ SAVE MGR │  │AUDIO MGR │  │ EVENT BUS│
        └──────────┘  └──────────┘  └──────────┘
```

---

## Sistemas Principales

### Ciclo de Vida de un Frame

```
1. _input(event)
   └── Capturar input del jugador
       └── Input.is_action_just_pressed("mine")

2. _process(delta)
   └── Actualizar lógica por frame
       ├── Actualizar linterna (batería)
       ├── Actualizar UI
       └── Procesar animaciones

3. _physics_process(delta)
   └── Actualizar lógica de física
       ├── Movimiento del jugador
       ├── Detección de colisiones
       └── Física de minerales

4. Señales
   └── Comunicación entre sistemas
       ├── mineral_mined → GameState.add_mineral()
       ├── damage_taken → AudioManager.play_sfx()
       └── depth_changed → Environment.update_biome()
```

---

## Autoloads

### GameState (`scripts/autoload/game_state.gd`)

**Responsabilidad**: Mantener el estado global del juego.

```gdscript
extends Node

# ─── Señales ──────────────────────────────────────────
signal phase_changed(new_phase: GamePhase)
signal depth_changed(new_depth: int)
signal mineral_changed(mineral_type: String, new_amount: int)
signal health_changed(new_health: int)
signal energy_changed(new_energy: int)

# ─── Enums ────────────────────────────────────────────
enum GamePhase {
    MENU,
    PLAYING,
    PAUSED,
    INVENTORY,
    SHOPPING,
    GAME_OVER
}

enum HorrorPhase {
    NONE,           # Solo ambiental
    LATENT,         # Señales sutiles
    STALKING,       # Criatura patrulla
    HUNTING         # Criatura activa
}

# ─── Estado del Jugador ──────────────────────────────
var current_phase: GamePhase = GamePhase.MENU
var horror_phase: HorrorPhase = HorrorPhase.NONE

var current_depth: int = 0
var max_depth_reached: int = 0

var health: int = 100
var max_health: int = 100

var energy: int = 100
var max_energy: int = 100

# ─── Inventario ──────────────────────────────────────
var inventory: Dictionary = {}  # { "copper": 15, "iron": 3 }
var inventory_capacity: int = 20
var inventory_used: int = 0

# ─── Dinero ──────────────────────────────────────────
var gold: int = 0

# ─── Progresión ──────────────────────────────────────
var flags: Dictionary = {}  # { "found_cursed_mineral": true }
var unlocked_upgrades: Array[String] = []

# ─── Métodos Públicos ────────────────────────────────
func change_phase(new_phase: GamePhase) -> void:
    current_phase = new_phase
    phase_changed.emit(new_phase)

func add_mineral(mineral_type: String, amount: int = 1) -> bool:
    var new_total = inventory.get(mineral_type, 0) + amount
    if new_total > _get_max_capacity(mineral_type):
        return false
    inventory[mineral_type] = new_total
    _update_inventory_used()
    mineral_changed.emit(mineral_type, new_total)
    return true

func remove_mineral(mineral_type: String, amount: int = 1) -> bool:
    var current = inventory.get(mineral_type, 0)
    if current < amount:
        return false
    inventory[mineral_type] = current - amount
    _update_inventory_used()
    mineral_changed.emit(mineral_type, inventory[mineral_type])
    return true

func change_depth(new_depth: int) -> void:
    current_depth = new_depth
    if new_depth > max_depth_reached:
        max_depth_reached = new_depth
    depth_changed.emit(new_depth)

func take_damage(amount: int) -> void:
    health = clampi(health - amount, 0, max_health)
    health_changed.emit(health)
    if health <= 0:
        _handle_death()

func set_flag(flag_name: String, value: bool = true) -> void:
    flags[flag_name] = value

func has_flag(flag_name: String) -> bool:
    return flags.get(flag_name, false)

# ─── Métodos Privados ────────────────────────────────
func _update_inventory_used() -> void:
    inventory_used = 0
    for mineral in inventory:
        inventory_used += inventory[mineral]

func _get_max_capacity(_mineral_type: String) -> int:
    return inventory_capacity

func _handle_death() -> void:
    change_phase(GamePhase.GAME_OVER)
```

### AudioManager (`scripts/autoload/audio_manager.gd`)

**Responsabilidad**: Gestión centralizada de audio.

```gdscript
extends Node

# ─── Configuración ───────────────────────────────────
const MAX_SFX_PLAYERS: int = 8

# ─── Nodos de Audio ──────────────────────────────────
var ambient_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var sfx_pool: Array[AudioStreamPlayer] = []
var voice_player: AudioStreamPlayer

# ─── Volumen Actual ──────────────────────────────────
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0
var ambient_volume: float = 1.0

# ─── Inicialización ──────────────────────────────────
func _ready() -> void:
    _setup_audio_players()

func _setup_audio_players() -> void:
    # Ambient player
    ambient_player = AudioStreamPlayer.new()
    ambient_player.bus = "Ambient"
    add_child(ambient_player)
    
    # Music player
    music_player = AudioStreamPlayer.new()
    music_player.bus = "Music"
    add_child(music_player)
    
    # SFX pool
    for i in MAX_SFX_PLAYERS:
        var player = AudioStreamPlayer.new()
        player.bus = "SFX"
        add_child(player)
        sfx_pool.append(player)
    
    # Voice player
    voice_player = AudioStreamPlayer.new()
    voice_player.bus = "Voice"
    add_child(voice_player)

# ─── Métodos Públicos ────────────────────────────────
func play_ambient(stream: AudioStream, fade_time: float = 1.0) -> void:
    if ambient_player.playing:
        # Fade out actual
        var tween = create_tween()
        tween.tween_property(ambient_player, "volume_db", -80.0, fade_time / 2)
        await tween.finished
    
    ambient_player.stream = stream
    ambient_player.volume_db = linear_to_db(ambient_volume * master_volume)
    ambient_player.play()
    
    # Fade in
    var tween = create_tween()
    tween.tween_property(ambient_player, "volume_db", 
        linear_to_db(ambient_volume * master_volume), fade_time / 2)

func play_sfx(stream: AudioStream, volume: float = 1.0, pitch: float = 1.0) -> void:
    var player = _get_free_sfx_player()
    if player:
        player.stream = stream
        player.volume_db = linear_to_db(volume * sfx_volume * master_volume)
        player.pitch_scale = pitch
        player.play()

func play_sfx_varied(stream: AudioStream, volume: float = 1.0, 
                       pitch_range: Vector2 = Vector2(0.9, 1.1)) -> void:
    var pitch = randf_range(pitch_range.x, pitch_range.y)
    play_sfx(stream, volume, pitch)

func play_music(stream: AudioStream, fade_time: float = 2.0) -> void:
    music_player.stream = stream
    music_player.volume_db = linear_to_db(music_volume * master_volume)
    music_player.play()

func stop_music(fade_time: float = 2.0) -> void:
    var tween = create_tween()
    tween.tween_property(music_player, "volume_db", -80.0, fade_time)
    await tween.finished
    music_player.stop()

func play_voice(stream: AudioStream) -> void:
    voice_player.stream = stream
    voice_player.play()

# ─── Métodos Privados ────────────────────────────────
func _get_free_sfx_player() -> AudioStreamPlayer:
    for player in sfx_pool:
        if not player.playing:
            return player
    return sfx_pool[0]  # Reemplazar el más antiguo
```

### SaveManager (`scripts/autoload/save_manager.gd`)

**Responsabilidad**: Persistencia de datos.

```gdscript
extends Node

const SAVE_PATH: String = "user://savegame.dat"
const SETTINGS_PATH: String = "user://settings.cfg"

# ─── Señales ──────────────────────────────────────────
signal game_saved
signal game_loaded
signal save_error(error: String)

# ─── Métodos Públicos ────────────────────────────────
func save_game() -> bool:
    var save_data = {
        "version": 1,
        "timestamp": Time.get_datetime_string_from_system(),
        "player": {
            "depth": GameState.current_depth,
            "max_depth": GameState.max_depth_reached,
            "health": GameState.health,
            "energy": GameState.energy,
            "gold": GameState.gold
        },
        "inventory": GameState.inventory.duplicate(),
        "flags": GameState.flags.duplicate(),
        "upgrades": GameState.unlocked_upgrades.duplicate()
    }
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        save_error.emit("No se pudo abrir archivo de guardado")
        return false
    
    file.store_var(save_data)
    file.close()
    game_saved.emit()
    return true

func load_game() -> bool:
    if not FileAccess.file_exists(SAVE_PATH):
        save_error.emit("No existe archivo de guardado")
        return false
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        save_error.emit("No se pudo leer archivo de guardado")
        return false
    
    var save_data = file.get_var()
    file.close()
    
    # Restaurar estado
    GameState.current_depth = save_data.player.depth
    GameState.max_depth_reached = save_data.player.max_depth
    GameState.health = save_data.player.health
    GameState.energy = save_data.player.energy
    GameState.gold = save_data.player.gold
    GameState.inventory = save_data.inventory.duplicate()
    GameState.flags = save_data.flags.duplicate()
    GameState.unlocked_upgrades = save_data.upgrades.duplicate()
    
    game_loaded.emit()
    return true

func delete_save() -> void:
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(SAVE_PATH)

func has_save() -> bool:
    return FileAccess.file_exists(SAVE_PATH)
```

---

## Sistema de Jugador

### Estructura de Nodos del Jugador

```
Player (CharacterBody3D)
├── CollisionShape3D
├── Head (Node3D)
│   ├── Camera3D
│   ├── Flashlight (SpotLight3D)
│   └── InteractionRay (RayCast3D)
├── Body (Node3D)
│   └── MeshInstance3D (placeholder)
└── AnimationPlayer
```

### Player.gd - Esqueleto

```gdscript
extends CharacterBody3D

# ─── Señales ──────────────────────────────────────────
signal flashlight_toggled(is_on: bool)
signal picked_up(item: Node3D)
signal interacted(body: Node3D)

# ─── Configuración ───────────────────────────────────
@export var speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var gravity: float = 9.8

# ─── Nodos ────────────────────────────────────────────
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Flashlight
@onready var interaction_ray: RayCast3D = $Head/InteractionRay

# ─── Estado ───────────────────────────────────────────
var flashlight_on: bool = true
var flashlight_battery: float = 100.0
var is_sprinting: bool = false
var current_tool: String = "pickaxe"

# ─── Referencia a la gravedad ────────────────────────
var _gravity_velocity: float = 0.0

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    GameState.health_changed.connect(_on_health_changed)

func _unhandled_input(event: InputEvent) -> void:
    if GameState.current_phase != GameState.GamePhase.PLAYING:
        return
    
    # Mouse look
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * mouse_sensitivity)
        head.rotate_x(-event.relative.y * mouse_sensitivity)
        head.rotation.x = clampf(head.rotation.x, -PI/2, PI/2)
    
    # Escape
    if event.is_action_pressed("ui_cancel"):
        _toggle_pause()

func _physics_process(delta: float) -> void:
    if GameState.current_phase != GameState.GamePhase.PLAYING:
        return
    
    # Gravedad
    if not is_on_floor():
        _gravity_velocity -= gravity * delta
    
    # Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        _gravity_velocity = jump_velocity
    
    # Sprint
    is_sprinting = Input.is_action_pressed("sprint")
    var current_speed = sprint_speed if is_sprinting else speed
    
    # Dirección de movimiento
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * current_speed
        velocity.z = direction.z * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)
        velocity.z = move_toward(velocity.z, 0, current_speed)
    
    velocity.y = _gravity_velocity
    
    move_and_slide()
    
    # Head bob
    _update_head_bob(delta)
    
    # Flashlight battery
    _update_flashlight(delta)
    
    # Interaction check
    _check_interaction()

# ─── Métodos ──────────────────────────────────────────
func _toggle_flashlight() -> void:
    flashlight_on = !flashlight_on
    flashlight.visible = flashlight_on
    flashlight_toggled.emit(flashlight_on)

func _update_head_bob(delta: float) -> void:
    if velocity.length() > 0.1 and is_on_floor():
        var bob_speed = 10.0 if is_sprinting else 8.0
        var bob_amount = 0.05 if is_sprinting else 0.03
        head.position.y = lerp(head.position.y, 
            sin(Time.get_ticks_msec() * 0.001 * bob_speed) * bob_amount, 
            delta * 10.0)

func _update_flashlight(delta: float) -> void:
    if flashlight_on:
        flashlight_battery -= delta * 2.0  # 2% por segundo
        flashlight_battery = maxf(flashlight_battery, 0.0)
        if flashlight_battery <= 0:
            _toggle_flashlight()
        
        # Intensidad basada en batería
        flashlight.light_energy = lerp(0.3, 1.0, flashlight_battery / 100.0)

func _check_interaction() -> void:
    if interaction_ray.is_colliding():
        var collider = interaction_ray.get_collider()
        if collider.has_method("interact"):
            # Mostrar UI de interacción
            pass

func _on_health_changed(new_health: int) -> void:
    if new_health <= 0:
        die()

func die() -> void:
    GameState.change_phase(GameState.GamePhase.GAME_OVER)
```

---

## Sistema de Minería

### MineralNode.gd

```gdscript
class_name MineralNode extends StaticBody3D

# ─── Señales ──────────────────────────────────────────
signal mined(node: MineralNode, amount: int)
signal destroyed(node: MineralNode)
signal health_changed(new_health: int)

# ─── Exported Properties ─────────────────────────────
@export var mineral_type: String = "copper"
@export var max_health: int = 100
@export var yield_amount: Vector2i = Vector2i(1, 3)
@export var rarity: float = 1.0

# ─── State ────────────────────────────────────────────
var current_health: int
var is_depleted: bool = false

# ─── Visual Feedback ─────────────────────────────────
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $BreakParticles
@onready var hit_sound: AudioStreamPlayer3D = $HitSound

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    current_health = max_health
    _setup_visual()

# ─── Public Methods ───────────────────────────────────
func take_damage(amount: int, tool_type: String = "pickaxe") -> void:
    if is_depleted:
        return
    
    # Modificador de daño por herramienta
    var damage_modifier = _get_tool_modifier(tool_type)
    var final_damage = int(amount * damage_modifier)
    
    current_health -= final_damage
    health_changed.emit(current_health)
    
    # Feedback visual
    _play_hit_animation()
    hit_sound.play()
    
    # Emitir señal de minería
    var actual_yield = randi_range(yield_amount.x, yield_amount.y)
    mined.emit(self, actual_yield)
    
    if current_health <= 0:
        _destroy()

func get_info() -> Dictionary:
    return {
        "type": mineral_type,
        "health": current_health,
        "max_health": max_health,
        "rarity": rarity,
        "depleted": is_depleted
    }

# ─── Private Methods ──────────────────────────────────
func _setup_visual() -> void:
    # Asignar material según tipo (placeholder)
    var material = StandardMaterial3D.new()
    material.albedo_color = _get_mineral_color()
    mesh.material_override = material

func _get_mineral_color() -> Color:
    match mineral_type:
        "copper": return Color(0.8, 0.4, 0.2)
        "iron": return Color(0.5, 0.5, 0.5)
        "silver": return Color(0.8, 0.8, 0.9)
        "gold": return Color(1.0, 0.84, 0.0)
        "crystal": return Color(0.4, 0.8, 1.0)
        _: return Color.WHITE

func _get_tool_modifier(tool_type: String) -> float:
    match tool_type:
        "pickaxe_basic": return 1.0
        "pickaxe_reinforced": return 1.5
        "drill": return 2.0
        _: return 1.0

func _play_hit_animation() -> void:
    var tween = create_tween()
    tween.tween_property(mesh, "position:x", mesh.position.x + 0.05, 0.05)
    tween.tween_property(mesh, "position:x", mesh.position.x, 0.05)

func _destroy() -> void:
    is_depleted = true
    # Efecto de destrucción
    if particles:
        particles.emitting = true
    # Ocultar nodo
    mesh.visible = false
    # Colisión off
    set_deferred("monitoring", false)
    destroyed.emit(self)
    # Eliminar después de un tiempo
    await get_tree().create_timer(2.0).timeout
    queue_free()
```

### PickaxeTool.gd

```gdscript
class_name PickaxeTool extends Node3D

# ─── Properties ───────────────────────────────────────
@export var tool_name: String = "Basic Pickaxe"
@export var damage: int = 25
@export var mining_speed: float = 1.0
@export var noise_level: float = 1.0
@export var durability: int = 100

# ─── State ────────────────────────────────────────────
var current_durability: int
var is_swinging: bool = false

# ─── Nodes ────────────────────────────────────────────
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var cooldown_timer: Timer = $CooldownTimer

# ─── Signals ──────────────────────────────────────────
signal tool_swung
signal tool_hit(node: Node3D)
signal durability_changed(new_durability: int)
signal broken

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    current_durability = durability
    cooldown_timer.one_shot = true

# ─── Public Methods ───────────────────────────────────
func use(interaction_ray: RayCast3D) -> bool:
    if is_swinging or not cooldown_timer.is_stopped():
        return false
    
    is_swinging = true
    animation.play("swing")
    
    # Check for hit
    if interaction_ray.is_colliding():
        var collider = interaction_ray.get_collider()
        if collider.has_method("take_damage"):
            collider.take_damage(damage, tool_name)
            _reduce_durability()
            tool_hit.emit(collider)
    
    tool_swung.emit()
    
    # Cooldown
    cooldown_timer.wait_time = 1.0 / mining_speed
    cooldown_timer.start()
    
    await animation.animation_finished
    is_swinging = false
    
    return true

func repair(amount: int) -> void:
    current_durability = mini(current_durability + amount, durability)
    durability_changed.emit(current_durability)

# ─── Private Methods ──────────────────────────────────
func _reduce_durability() -> void:
    current_durability -= 1
    durability_changed.emit(current_durability)
    
    if current_durability <= 0:
        broken.emit()
        # Efecto visual de rotura
        mesh.visible = false
```

---

## Sistema de Inventario

### Inventory.gd

```gdscript
class_name Inventory extends RefCounted

# ─── Señales ──────────────────────────────────────────
signal item_added(item_id: String, amount: int)
signal item_removed(item_id: String, amount: int)
signal inventory_full
signal inventory_changed

# ─── Properties ───────────────────────────────────────
var items: Dictionary = {}  # { "copper": { "amount": 10, "data": {} } }
var max_slots: int = 20
var max_stack_size: int = 99

# ─── Public Methods ───────────────────────────────────
func add_item(item_id: String, amount: int = 1, item_data: Dictionary = {}) -> bool:
    # Check if we have space
    if not _has_space_for(item_id, amount):
        inventory_full.emit()
        return false
    
    # Add to existing stack or new slot
    if items.has(item_id):
        items[item_id].amount += amount
    else:
        items[item_id] = {
            "amount": amount,
            "data": item_data
        }
    
    item_added.emit(item_id, amount)
    inventory_changed.emit()
    return true

func remove_item(item_id: String, amount: int = 1) -> bool:
    if not items.has(item_id):
        return false
    
    if items[item_id].amount < amount:
        return false
    
    items[item_id].amount -= amount
    
    if items[item_id].amount <= 0:
        items.erase(item_id)
    
    item_removed.emit(item_id, amount)
    inventory_changed.emit()
    return true

func get_amount(item_id: String) -> int:
    return items.get(item_id, {}).get("amount", 0)

func has_item(item_id: String, amount: int = 1) -> bool:
    return get_amount(item_id) >= amount

func get_all_items() -> Dictionary:
    return items.duplicate(true)

func get_used_slots() -> int:
    return items.size()

func get_free_slots() -> int:
    return max_slots - get_used_slots()

func clear() -> void:
    items.clear()
    inventory_changed.emit()

# ─── Private Methods ──────────────────────────────────
func _has_space_for(item_id: String, amount: int) -> bool:
    if items.has(item_id):
        return items[item_id].amount + amount <= max_stack_size
    return get_free_slots() > 0
```

---

## Sistema de Entorno

### MineGenerator.gd (Esqueleto)

```gdscript
class_name MineGenerator extends Node3D

# ─── Configuration ────────────────────────────────────
@export var chunk_size: Vector2i = Vector2i(16, 16)
@export var render_distance: int = 3
@export var mine_depth: int = 10

# ─── Resources ────────────────────────────────────────
@export var tunnel_scenes: Array[PackedScene] = []
@export var room_scenes: Array[PackedScene] = []
@export var mineral_scenes: Dictionary = {}

# ─── State ────────────────────────────────────────────
var generated_chunks: Dictionary = {}
var current_chunk: Vector2i = Vector2i.ZERO

# ─── Signals ──────────────────────────────────────────
signal chunk_generated(chunk_pos: Vector2i)
signal biome_changed(biome_name: String)

# ─── Public Methods ───────────────────────────────────
func generate_initial_mine() -> void:
    # Generate starting area
    _generate_chunk(Vector2i.ZERO)
    _generate_surrounding_chunks(Vector2i.ZERO)

func get_biome_at_depth(depth: int) -> String:
    # Return biome based on depth
    if depth < 3:
        return "shallow"
    elif depth < 6:
        return "crystal"
    elif depth < 8:
        return "abandoned"
    else:
        return "deep"

# ─── Private Methods ──────────────────────────────────
func _generate_chunk(chunk_pos: Vector2i) -> void:
    if generated_chunks.has(chunk_pos):
        return
    
    # TODO: Implement chunk generation
    # 1. Determine biome
    # 2. Select appropriate scenes
    # 3. Generate layout
    # 4. Place minerals
    # 5. Add lighting
    
    generated_chunks[chunk_pos] = true
    chunk_generated.emit(chunk_pos)

func _generate_surrounding_chunks(center: Vector2i) -> void:
    for x in range(-render_distance, render_distance + 1):
        for y in range(-render_distance, render_distance + 1):
            var pos = center + Vector2i(x, y)
            _generate_chunk(pos)
```

---

## Sistema de Audio

### AmbientZone.gd

```gdscript
class_name AmbientZone extends Area3D

# ─── Configuration ────────────────────────────────────
@export var ambient_streams: Array[AudioStream] = []
@export var volume: float = 1.0
@export var fade_time: float = 2.0
@export var randomize_pitch: bool = false
@export var pitch_range: Vector2 = Vector2(0.9, 1.1)

# ─── State ────────────────────────────────────────────
var is_active: bool = false

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        _activate()

func _on_body_exited(body: Node3D) -> void:
    if body.is_in_group("player"):
        _deactivate()

func _activate() -> void:
    if is_active:
        return
    is_active = true
    
    if ambient_streams.size() > 0:
        var stream = ambient_streams[randi() % ambient_streams.size()]
        AudioManager.play_ambient(stream, fade_time)

func _deactivate() -> void:
    if not is_active:
        return
    is_active = false
    # AudioManager will handle fade out
```

---

## Sistema de UI

### HUD.gd (Esqueleto)

```gdscript
extends CanvasLayer

# ─── Nodes ────────────────────────────────────────────
@onready var health_bar: ProgressBar = $MarginContainer/VBoxLeft/HealthBar
@onready var energy_bar: ProgressBar = $MarginContainer/VBoxLeft/EnergyBar
@onready var battery_indicator: TextureRect = $MarginContainer/VBoxRight/BatteryIndicator
@onready var depth_label: Label = $MarginContainer/VBoxRight/DepthLabel
@onready var gold_label: Label = $MarginContainer/HBoxTop/GoldLabel
@onready var crosshair: TextureRect = $Crosshair
@onready var interaction_prompt: Label = $InteractionPrompt

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    GameState.health_changed.connect(_on_health_changed)
    GameState.energy_changed.connect(_on_energy_changed)
    GameState.depth_changed.connect(_on_depth_changed)

# ─── Update Methods ───────────────────────────────────
func _on_health_changed(new_health: int) -> void:
    health_bar.value = new_health

func _on_energy_changed(new_energy: int) -> void:
    energy_bar.value = new_energy

func _on_depth_changed(new_depth: int) -> void:
    depth_label.text = "Profundidad: %dm" % new_depth

func update_gold(amount: int) -> void:
    gold_label.text = "Oro: %d" % amount

func show_interaction_prompt(text: String) -> void:
    interaction_prompt.text = text
    interaction_prompt.visible = true

func hide_interaction_prompt() -> void:
    interaction_prompt.visible = false
```

---

## Guardado y Carga

Ver [SaveManager en Autoloads](#autoloads).

### Formato de Save

```json
{
    "version": 1,
    "timestamp": "2026-06-25T12:00:00Z",
    "player": {
        "depth": 5,
        "max_depth": 7,
        "health": 85,
        "energy": 70,
        "gold": 1250
    },
    "inventory": {
        "copper": 25,
        "iron": 12,
        "crystal": 2
    },
    "flags": {
        "found_cursed_mineral": true,
        "met_old_miner": true
    },
    "upgrades": [
        "pickaxe_reinforced",
        "lantern_upgrade_1"
    ]
}
```

---

## Generación Procedural

Ver [MineGenerator.gd](#minegeneratorgd-esqueleto).

### Algoritmo de Generación

```
1. Determinar profundidad actual → bioma
2. Seleccionar sala prefabricada según bioma
3. Conectar con túneles generados
4. Poblar con minerales según rareza del bioma
5. Añadir puntos de luz y decoración
6. Generar zonas de audio ambiente
```

### Biomas

| Profundidad | Bioma | Características |
|-------------|-------|-----------------|
| 0-2 | Superficie | Campamento, seguridad |
| 1-3 | Shallow | Fácil, minerales básicos |
| 4-5 | Crystal | Cristales, más luz natural |
| 6-7 | Abandoned | Estructuras rotas, peligro |
| 8-9 | Deep | Oscuro, minerales raros |
| 10+ | Cursed | Horror activo |

---

## Sistema de Horror

Ver [Fase 3 del Roadmap](../design/game_design.md#fase-3).

### Estados de la Criatura

```
AUSENTE → ACECHANDO → CAZANDO → (perdió al jugador) → ACECHANDO
    │                                                      │
    └────────────────── (reset) ───────────────────────────┘
```

### Detección

| Fuente | Nivel de Rango | Efecto |
|--------|----------------|--------|
| Picar mineral | Alto | Atrae criatura |
| Correr | Medio | Alerta criatura |
| Linterna encendida | Bajo | Detección cercana |
| Quedarse quieto | Ninguno | Seguridad relativa |

---

## Documentación Adicional

- [Coding Standards](coding_standards.md) - Convenciones de código
- [Asset Pipeline](../design/asset_pipeline.md) - Flujo de trabajo con assets
- [Game Design](../design/game_design.md) - Documento de diseño completo