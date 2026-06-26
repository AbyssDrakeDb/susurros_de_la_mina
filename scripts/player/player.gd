extends CharacterBody3D
class_name Player

## ─── Señales ──────────────────────────────────────────
signal flashlight_toggled(is_on: bool)
signal interacted(body: Node3D)
signal mine_hit(body: Node3D)

## ─── Configuración ───────────────────────────────────
@export var speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var gravity: float = 20.0

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

## ─── Constantes ───────────────────────────────────────
const FLASHLIGHT_DRAIN_RATE: float = 2.0
const HEAD_BOB_SPEED_WALK: float = 8.0
const HEAD_BOB_SPEED_SPRINT: float = 10.0
const HEAD_BOB_AMOUNT_WALK: float = 0.03
const HEAD_BOB_AMOUNT_SPRINT: float = 0.05

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -PI / 2.0, PI / 2.0)
	
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
	
	if event.is_action_pressed("toggle_flashlight"):
		_toggle_flashlight()
	
	if event.is_action_pressed("mine"):
		_try_mine()

func _physics_process(delta: float) -> void:
	if GameState.current_phase != GameState.GamePhase.PLAYING:
		return
	
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Movimiento
	is_sprinting = Input.is_action_pressed("sprint")
	var current_speed: float = sprint_speed if is_sprinting else speed
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_speed)
		velocity.z = move_toward(velocity.z, 0.0, current_speed)
	
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
	if velocity.length() > 0.1 and is_on_floor():
		var bob_speed: float = HEAD_BOB_SPEED_SPRINT if is_sprinting else HEAD_BOB_SPEED_WALK
		var bob_amount: float = HEAD_BOB_AMOUNT_SPRINT if is_sprinting else HEAD_BOB_AMOUNT_WALK
		_head_bob_time += delta * bob_speed
		var target_y: float = sin(_head_bob_time) * bob_amount
		head.position.y = lerp(head.position.y, target_y, delta * 10.0)
	else:
		head.position.y = lerp(head.position.y, 0.0, delta * 10.0)

## ─── Minado ───────────────────────────────────────────
func _try_mine() -> void:
	if interaction_ray.is_colliding():
		var collider: Node3D = interaction_ray.get_collider()
		if collider and collider.has_method("take_damage"):
			collider.take_damage(25, "pickaxe_basic")
			mine_hit.emit(collider)

## ─── Pausa ────────────────────────────────────────────
func _toggle_pause() -> void:
	if GameState.current_phase == GameState.GamePhase.PLAYING:
		GameState.change_phase(GameState.GamePhase.PAUSED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	elif GameState.current_phase == GameState.GamePhase.PAUSED:
		GameState.change_phase(GameState.GamePhase.PLAYING)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
