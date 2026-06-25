# Convenciones de Código - Susurros de la Mina

**Versión**: 1.0  
**Última actualización**: 25 de Junio, 2026

---

## Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Nomenclatura](#nomenclatura)
3. [Estructura de Scripts](#estructura-de-scripts)
4. [Estructura de Escenas](#estructura-de-escenas)
5. [Comentarios y Documentación](#comentarios-y-documentación)
6. [Errores y Debugging](#errores-y-debugging)
7. [Performance](#performance)
8. [Git y Versiones](#git-y-versiones)

---

## Visión General

### Principios

1. **Consistencia**: Seguir el mismo estilo en todo el proyecto
2. **Legibilidad**: Código que se lee como un libro
3. **Simplicidad**: Soluciones simples sobre complejas
4. **Maintenability**: Fácil de modificar y extender

### Herramientas Recomendadas

- **Editor**: VS Code con extensión [Godot Tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)
- **Linter**: [gdtoolkit](https://github.com/Scony/godot-gdscript-toolkit) (format)
- **Formatter**: Integrado en Godot Editor

---

## Nomenclatura

### Clases y Nombres de Tipo

```gdscript
# ✅ Correcto - PascalCase
class_name MineralNode extends StaticBody3D
class_name PlayerController extends CharacterBody3D

# ❌ Incorrecto
class_name mineralNode extends StaticBody3D
class_name player_controller extends CharacterBody3D
```

### Variables

```gdscript
# ✅ Correcto - snake_case
var current_health: int = 100
var is_sprinting: bool = false
var mineral_type: String = "copper"

# ❌ Incorrecto
var currentHealth: int = 100
var IsSprinting: bool = false
var MineralType: String = "copper"
```

### Constantes

```gdscript
# ✅ Correcto - SCREAMING_SNAKE_CASE
const MAX_HEALTH: int = 100
const GRAVITY: float = 9.8
const MINERAL_TYPES: Array[String] = ["copper", "iron", "gold"]

# ❌ Incorrecto
const maxHealth: int = 100
const gravity: float = 9.8
```

### Funciones

```gdscript
# ✅ Correcto - snake_case, verbos en infinitivo
func take_damage(amount: int) -> void:
func get_mineral_info() -> Dictionary:
func is_on_floor() -> bool:
func _setup_audio_players() -> void:  # Private con _

# ❌ Incorrecto
func TakeDamage(amount: int) -> void:
func GetMineralInfo() -> Dictionary:
func setupAudioPlayers() -> void:
```

### Señales

```gdscript
# ✅ Correcto - snake_case, nombre descriptivo
signal health_changed(new_health: int)
signal mineral_mined(mineral_type: String, amount: int)
signal player_died

# ❌ Incorrecto
signal healthChanged(new_health: int)
signal mineralMined
signal OnPlayerDeath
```

### Nodos (en escenas)

```gdscript
# ✅ Correcto - snake_case con prefijo del tipo
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Flashlight

# En editor: Nombre descriptivo
# Player/Head/Camera3D
# Player/Head/Flashlight
```

### Archivos

```
✅ Correcto:
mineral_node.gd
player_controller.gd
game_state.gd

❌ Incorrecto:
MineralNode.gd
PlayerController.gd
GameState.gd
```

---

## Estructura de Scripts

### Plantilla Básica

```gdscript
extends Node3D
class_name MyClass

# ─── Señales ──────────────────────────────────────────
signal example_signal(param: Type)

# ─── Enums ────────────────────────────────────────────
enum State { IDLE, RUNNING, JUMPING }

# ─── Constantes ───────────────────────────────────────
const MAX_VALUE: int = 100

# ─── Exported Properties ─────────────────────────────
@export var speed: float = 5.0
@export var health: int = 100

# ─── Public Variables ─────────────────────────────────
var current_state: State = State.IDLE

# ─── Private Variables ────────────────────────────────
var _internal_counter: int = 0

# ─── Onready Variables ────────────────────────────────
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

# ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    pass

# ─── Public Methods ───────────────────────────────────
func do_something() -> void:
    pass

# ─── Private Methods ──────────────────────────────────
func _internal_method() -> void:
    pass

# ─── Signal Handlers ──────────────────────────────────
func _on_timer_timeout() -> void:
    pass
```

### Orden de Secciones

1. Señales
2. Enums
3. Constantes
4. Variables exportadas
5. Variables públicas
6. Variables privadas
7. Onready variables
8. Callbacks de Godot (_ready, _process, etc.)
9. Métodos públicos
10. Métodos privados
11. Manejadores de señales

---

## Estructura de Escenas

### Organización de Nodos

```
Player (CharacterBody3D)           # Nodo raíz con tipo claro
├── CollisionShape3D               # Colisión principal
├── Head (Node3D)                  # Punto de rotación
│   ├── Camera3D                  # Cámara del jugador
│   ├── Flashlight (SpotLight3D)  # Linterna
│   └── InteractionRay (RayCast3D) # Detección de interacción
├── Body (Node3D)                  # Modelo visual
│   └── MeshInstance3D
└── AnimationPlayer                # Animaciones

MineralNode (StaticBody3D)
├── CollisionShape3D
├── MeshInstance3D                 # Visual del mineral
├── GPUParticles3D                 # Partículas al romperse
├── AudioStreamPlayer3D            # Sonido al golpear
└── HealthComponent                # Componente reutilizable
```

### Reglas

1. **Un nodo raíz por escena**: Que represente claramente qué es
2. **Nodos de tipo explícito**: Siempre usar el tipo de nodo base
3. **Nombres descriptivos**: No abreviar (`Camera` en lugar de `Cam`)
4. **Agrupar por funcionalidad**: Nodos relacionados juntos

---

## Comentarios y Documentación

### En Código

```gdscript
# ✅ Correcto - Comentario explicativo
# Calculamos la daño basado en la distancia
var distance_factor = 1.0 - (distance / max_distance)
var final_damage = base_damage * distance_factor

# ❌ Incorrecto - Comentario obvio
var distance_factor = 1.0 - (distance / max_distance)  # Calcula factor de distancia
```

### Documentación de Funciones

```gdscript
## Aplica daño al mineral y retorna si fue destruido.
##
## @param amount: Cantidad de daño a aplicar
## @param tool_type: Tipo de herramienta usada (modifica el daño)
## @return: true si el mineral fue destruido
func take_damage(amount: int, tool_type: String = "pickaxe") -> bool:
    # ...
    return is_depleted
```

### TODO y FIXME

```gdscript
# TODO: Implementar generación procedural
# FIXME: Bug con la linterna al cargar partida
# HACK: Solución temporal hasta encontrar la causa
# NOTE: Este sistema depende de GameState autoload
```

---

## Errores y Debugging

### Manejo de Errores

```gdscript
# ✅ Correcto - Verificar antes de usar
func play_sound(sound: AudioStream) -> void:
    if sound == null:
        push_warning("Intentando reproducir sonido nulo")
        return
    audio_player.stream = sound
    audio_player.play()

# ❌ Incorrecto - Asunción peligrosa
func play_sound(sound: AudioStream) -> void:
    audio_player.stream = sound  # Puede fallar si sound es null
    audio_player.play()
```

### Push Errors y Warnings

```gdscript
# Para errores críticos
push_error("Error fatal: No se pudo cargar el sistema de guardado")

# Para advertencias
push_warning("La linterna no tiene batería")

# Para debug (solo visible en editor/debug)
print_debug("Estado actual: ", current_state)
```

### Assertions

```gdscript
# Usar para invariantes que NUNCA deben fallar
assert(health >= 0, "La salud no puede ser negativa")
assert(current_tool != "", "Siempre debe haber una herramienta equipada")
```

---

## Performance

### Reglas Generales

1. **Evitar `_process` innecesario**: Usar señales cuando sea posible
2. **Object Pooling**: Reutilizar nodos en lugar de crear/destruir
3. **Lazy Loading**: Cargar recursos solo cuando se necesiten
4. **Profiling**: Usar el monitor de rendimiento de Godot

### Ejemplos

```gdscript
# ✅ Correcto - Usar señales
func take_damage(amount: int) -> void:
    health -= amount
    health_changed.emit(health)  # UI escucha la señal

# ❌ Incorrecto - Polling en _process
func _process(delta: float) -> void:
    health_bar.value = health  # Se actualiza cada frame innecesariamente
```

```gdscript
# ✅ Correcto - Object pooling
var bullet_pool: Array[Node] = []

func get_bullet() -> Node:
    if bullet_pool.size() > 0:
        return bullet_pool.pop_back()
    return bullet_scene.instantiate()

func return_bullet(bullet: Node) -> void:
    bullet_pool.append(bullet)
```

---

## Git y Versiones

### Mensajes de Commit

```
✅ Correcto:
feat: add mining system
fix: flashlight battery drain rate
refactor: extract inventory logic
docs: update architecture.md
test: add mineral node tests

❌ Incorrecto:
updated stuff
fixed bug
WIP
```

### Ramas

```
main                    # Estable, listo para release
├── develop             # Integración
│   ├── feature/mining      # Nueva feature
│   ├── feature/inventory   # Nueva feature
│   └── bugfix/flashlight   # Fix de bug
```

### Archivos Importantes

```gitignore
# Godot
.godot/
*.import

# Sistema
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Builds
builds/
export/
```

---

## Checklist de Revisión

Antes de hacer commit:

- [ ] Código sigue las convenciones de nomenclatura
- [ ] No hay errores de tipos (usar typed GDScript)
- [ ] Funciones públicas tienen documentación
- [ ] No hay código muerto o comentarios innecesarios
- [ ] Señales se emiten correctamente
- [ ] No hay reference cycles potenciales
- [ ] El código compila sin warnings

---

## Recursos

- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Godot Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)
- [GDToolkit](https://github.com/Scony/godot-gdscript-toolkit)