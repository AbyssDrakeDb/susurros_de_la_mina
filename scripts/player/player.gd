extends CharacterBody3D
class_name Player

## ─── Señales ──────────────────────────────────────────
signal flashlight_toggled(is_on: bool)
signal interacted(body: Node3D)
signal mine_hit(body: Node3D)

## ─── Configuración ───────────────────────────────────
@export var speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var gravity: float = 20.0
@export var acceleration: float = 10.0
@export var deceleration: float = 8.0

## ─── Nodos ────────────────────────────────────────────
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Flashlight
@onready var interaction_ray: RayCast3D = $Head/InteractionRay

## ─── Estado ───────────────────────────────────────────
var flashlight_on: bool = true
var flashlight_battery: float = 100.0
var is_sprinting: bool = false
var _head_bob_time: float = 0.0
var _head_bob_offset: float = 0.0
var is_paused: bool = false

## ─── Constantes ───────────────────────────────────────
const FLASHLIGHT_DRAIN_RATE: float = 2.0
const HEAD_BOB_SPEED_WALK: float = 8.0
const HEAD_BOB_SPEED_SPRINT: float = 10.0
const HEAD_BOB_AMOUNT_WALK: float = 0.03
const HEAD_BOB_AMOUNT_SPRINT: float = 0.05

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Mouse look - siempre activo
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not is_paused:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -PI / 2.0, PI / 2.0)
	
	# Pausa - funciona incluso cuando el árbol está pausado
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
	
	# Minado - en _input para que funcione con click
	if event.is_action_pressed("mine") and not is_paused:
		_try_mine()
	
	# Linterna
	if event.is_action_pressed("toggle_flashlight") and not is_paused:
		_toggle_flashlight()

func _physics_process(delta: float) -> void:
	if is_paused:
		return
	
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Movimiento con aceleración suave
	is_sprinting = Input.is_action_pressed("sprint")
	var target_speed: float = sprint_speed if is_sprinting else speed
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity: Vector3 = direction * target_speed
	
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)
	
	move_and_slide()
	
	# Head bob
	_update_head_bob(delta)
	
	# Flashlight
	_update_flashlight(delta)

## ─── Linterna ─────────────────────────────────────────
func _toggle_flashlight() -> void:
	flashlight_on = !flashlight_on
	flashlight.visible = flashlight_on
	flashlight_toggled.emit(flashlight_on)

func _update_flashlight(delta: float) -> void:
	if flashlight_on:
		flashlight_battery -= delta * FLASHLIGHT_DRAIN_RATE
		flashlight_battery = maxf(flashlight_battery, 0.0)
		if flashlight_battery <= 0.0:
			_toggle_flashlight()
		flashlight.light_energy = lerpf(0.3, 1.0, flashlight_battery / 100.0)

## ─── Head Bob ─────────────────────────────────────────
func _update_head_bob(delta: float) -> void:
	var is_moving: bool = velocity.length() > 0.5 and is_on_floor()
	
	if is_moving:
		var bob_speed: float = HEAD_BOB_SPEED_SPRINT if is_sprinting else HEAD_BOB_SPEED_WALK
		var bob_amount: float = HEAD_BOB_AMOUNT_SPRINT if is_sprinting else HEAD_BOB_AMOUNT_WALK
		_head_bob_time += delta * bob_speed
		_head_bob_offset = sin(_head_bob_time) * bob_amount
	else:
		_head_bob_time = 0.0
		_head_bob_offset = lerp(_head_bob_offset, 0.0, delta * 8.0)
	
	head.position.y = lerp(head.position.y, _head_bob_offset, delta * 10.0)

## ─── Minado ───────────────────────────────────────────
func _try_mine() -> void:
	if interaction_ray.is_colliding():
		var collider: Node3D = interaction_ray.get_collider()
		print("[Player] Mining: ", collider.name)
		if collider and collider.has_method("take_damage"):
			collider.take_damage(25, "pickaxe_basic")
			mine_hit.emit(collider)
			print("[Player] Damage applied to: ", collider.name)
		else:
			print("[Player] Collider has no take_damage method")

## ─── Pausa ────────────────────────────────────────────
func _toggle_pause() -> void:
	if is_paused:
		is_paused = false
		GameState.change_phase(GameState.GamePhase.PLAYING)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		print("[Player] Unpaused")
	else:
		is_paused = true
		GameState.change_phase(GameState.GamePhase.PAUSED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		print("[Player] Paused")
