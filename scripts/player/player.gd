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
@export var acceleration: float = 12.0
@export var deceleration: float = 20.0
@export var base_damage: int = 25

## ─── Nodos ────────────────────────────────────────────
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Flashlight
@onready var interaction_ray: RayCast3D = $Head/InteractionRay
@onready var pickaxe_pivot: Node3D = $Head/Camera3D/PickaxePivot
@onready var pickaxe_mesh: MeshInstance3D = $Head/Camera3D/PickaxePivot/PickaxeMesh
@onready var mining_label: Label3D = $Head/Camera3D/MiningLabel

## ─── Estado ───────────────────────────────────────────
var flashlight_on: bool = true
var flashlight_battery: float = 100.0
var is_sprinting: bool = false
var _head_bob_time: float = 0.0
var _head_bob_offset: float = 0.0
var is_paused: bool = false
var is_mining: bool = false
var mining_target: Node3D = null
var _pickaxe_swing_time: float = 0.0
var _was_on_floor: bool = true
var _fall_start_y: float = 0.0

## ─── Constantes ───────────────────────────────────────
const FLASHLIGHT_DRAIN_RATE: float = 2.0
const HEAD_BOB_SPEED_WALK: float = 8.0
const HEAD_BOB_SPEED_SPRINT: float = 10.0
const HEAD_BOB_AMOUNT_WALK: float = 0.03
const HEAD_BOB_AMOUNT_SPRINT: float = 0.05
const PICKAXE_SWING_SPEED: float = 8.0
const PICKAXE_SWING_AMOUNT: float = 0.15
const FOOTSTEP_INTERVAL_WALK: float = 0.45
const FOOTSTEP_INTERVAL_SPRINT: float = 0.35
const FALL_DAMAGE_THRESHOLD: float = 5.0
const FALL_DAMAGE_PER_UNIT: float = 10

## ─── Audio ────────────────────────────────────────────
var _footstep_timer: float = 0.0
var _mining_sounds: Array[AudioStream] = []
var _footstep_sounds: Array[AudioStream] = []

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group("player")
	_setup_pickaxe()
	_load_audio()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not is_paused:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -PI / 2.0, PI / 2.0)
	
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
	
	if event.is_action_pressed("mine") and not is_paused:
		_try_mine()
	
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
	
	# Movimiento con frenado fuerte
	is_sprinting = Input.is_action_pressed("sprint")
	var speed_multiplier: float = GameState.get_speed_multiplier()
	var target_speed: float = (sprint_speed if is_sprinting else speed) * speed_multiplier
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, direction.x * target_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * target_speed, acceleration * delta)
	else:
		# Frenado fuerte - reduce deslizamiento
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)
	
	move_and_slide()
	
	# Detección de caída
	_check_fall_damage()
	
	# Head bob
	_update_head_bob(delta)
	
	# Flashlight
	_update_flashlight(delta)
	
	# Mining check
	_update_mining_indicator()
	
	# Pickaxe animation
	_update_pickaxe_swing(delta)
	
	# Audio de pasos
	_update_footsteps(delta)

## ─── Audio ────────────────────────────────────────────
func _load_audio() -> void:
	for i in range(5):
		_mining_sounds.append(load("res://assets/audio/sfx/mining/impactMining_%03d.ogg" % i))
		_footstep_sounds.append(load("res://assets/audio/sfx/player/footstep_concrete_%03d.ogg" % i))

func _play_footstep() -> void:
	if _footstep_sounds.size() > 0:
		AudioManager.play_sfx_varied(_footstep_sounds[randi() % _footstep_sounds.size()])

func _update_footsteps(delta: float) -> void:
	var is_moving: bool = velocity.length() > 0.5 and is_on_floor()
	if is_moving:
		var interval: float = FOOTSTEP_INTERVAL_SPRINT if is_sprinting else FOOTSTEP_INTERVAL_WALK
		_footstep_timer -= delta
		if _footstep_timer <= 0.0:
			_play_footstep()
			_footstep_timer = interval
	else:
		_footstep_timer = 0.0

## ─── Picota ───────────────────────────────────────────
func _setup_pickaxe() -> void:
	if pickaxe_pivot:
		pickaxe_pivot.position = Vector3(0.3, -0.3, -0.5)
		pickaxe_pivot.rotation_degrees = Vector3(-20, -10, 0)
	
	if mining_label:
		mining_label.visible = false

func _update_mining_indicator() -> void:
	if interaction_ray.is_colliding():
		var collider: Node3D = interaction_ray.get_collider()
		if collider and collider.has_method("take_damage"):
			mining_target = collider
			if mining_label:
				mining_label.visible = true
				mining_label.text = "[ CLICK ]"
		else:
			mining_target = null
			if mining_label:
				mining_label.visible = false
	else:
		mining_target = null
		if mining_label:
			mining_label.visible = false

func _update_pickaxe_swing(delta: float) -> void:
	if not pickaxe_pivot:
		return
	
	if is_mining:
		_pickaxe_swing_time += delta * PICKAXE_SWING_SPEED
		var swing: float = sin(_pickaxe_swing_time) * PICKAXE_SWING_AMOUNT
		pickaxe_pivot.rotation.x = lerp(pickaxe_pivot.rotation.x, -0.3 + swing, delta * 15.0)
	else:
		_pickaxe_swing_time = 0.0
		pickaxe_pivot.rotation.x = lerp(pickaxe_pivot.rotation.x, -0.3, delta * 8.0)

func _start_mining_animation() -> void:
	is_mining = true
	_pickaxe_swing_time = 0.0

func _stop_mining_animation() -> void:
	is_mining = false

## ─── Linterna ─────────────────────────────────────────
func _toggle_flashlight() -> void:
	flashlight_on = !flashlight_on
	flashlight.visible = flashlight_on
	flashlight_toggled.emit(flashlight_on)

func _update_flashlight(delta: float) -> void:
	if flashlight_on:
		var battery_multiplier: float = GameState.get_battery_multiplier()
		flashlight_battery -= delta * FLASHLIGHT_DRAIN_RATE / battery_multiplier
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
		if collider and collider.has_method("take_damage"):
			_start_mining_animation()
			var total_damage: int = base_damage + GameState.get_damage_bonus()
			collider.take_damage(total_damage, "pickaxe_basic")
			mine_hit.emit(collider)
			if _mining_sounds.size() > 0:
				AudioManager.play_sfx_varied(_mining_sounds[randi() % _mining_sounds.size()])
			get_tree().create_timer(0.3).timeout.connect(_stop_mining_animation)

## ─── Pausa ────────────────────────────────────────────
func _toggle_pause() -> void:
	if is_paused:
		is_paused = false
		GameState.change_phase(GameState.GamePhase.PLAYING)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	else:
		is_paused = true
		GameState.change_phase(GameState.GamePhase.PAUSED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

## ─── Daño por Caída ───────────────────────────────────
func _check_fall_damage() -> void:
	if is_on_floor():
		if not _was_on_floor:
			var fall_distance: float = _fall_start_y - position.y
			if fall_distance > FALL_DAMAGE_THRESHOLD:
				var damage: int = int((fall_distance - FALL_DAMAGE_THRESHOLD) * FALL_DAMAGE_PER_UNIT)
				GameState.take_damage(damage)
		_was_on_floor = true
		_fall_start_y = position.y
	else:
		if _was_on_floor:
			_fall_start_y = position.y
		_was_on_floor = false

func _handle_death() -> void:
	GameState.change_phase(GameState.GamePhase.GAME_OVER)
