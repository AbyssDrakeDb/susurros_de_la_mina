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
	GameState.phase_changed.connect(_on_phase_changed)

func _input(event: InputEvent) -> void:
	if is_paused:
		return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clampf(head.rotation.x, -PI / 2.0, PI / 2.0)
	
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
	
	if event.is_action_pressed("mine") and not is_paused:
		_try_mine()
	
	if event.is_action_pressed("toggle_flashlight") and not is_paused:
		_toggle_flashlight()
	
	if event.is_action_pressed("use_battery") and not is_paused:
		_use_battery()

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

func _use_battery() -> void:
	if GameState.use_battery():
		flashlight_battery = 100.0
		_update_hud_battery()
		if flashlight_on:
			flashlight.light_energy = 1.0
		_show_notification("Pila usada! Pilas restantes: %d" % GameState.battery_cells)
	else:
		_show_notification("No tienes pilas! (R)")

func _show_notification(text: String) -> void:
	var label: Label3D = Label3D.new()
	label.text = text
	label.font_size = 20
	label.modulate = Color(1, 1, 0.5)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	label.pixel_size = 0.003
	head.add_child(label)
	label.position = Vector3(0, -0.3, -1.5)
	
	var tween: Tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(label.queue_free)

func _update_flashlight(delta: float) -> void:
	if flashlight_on:
		var battery_multiplier: float = GameState.get_battery_multiplier()
		flashlight_battery -= delta * FLASHLIGHT_DRAIN_RATE / battery_multiplier
		flashlight_battery = maxf(flashlight_battery, 0.0)
		if flashlight_battery <= 0.0:
			_toggle_flashlight()
			if GameState.battery_cells > 0:
				_show_notification("Linterna agotada! Presiona R para recargar")
		flashlight.light_energy = lerpf(0.3, 1.0, flashlight_battery / 100.0)
		_update_hud_battery()

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
	if GameState.current_phase == GameState.GamePhase.GAME_OVER:
		return
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

func _on_phase_changed(new_phase: GameState.GamePhase) -> void:
	match new_phase:
		GameState.GamePhase.GAME_OVER:
			is_paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_show_game_over_screen()

func _show_game_over_screen() -> void:
	var overlay: CanvasLayer = CanvasLayer.new()
	overlay.layer = 100
	get_tree().current_scene.add_child(overlay)
	
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.85)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(bg)
	
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	vbox.custom_minimum_size = Vector2(400, 200)
	vbox.position = Vector2(-200, -100)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	bg.add_child(vbox)
	
	var title: Label = Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var total: int = 0
	for mineral in GameState.inventory:
		total += GameState.inventory[mineral]
	
	var stats: Label = Label.new()
	stats.text = "Oro: %d | Mineral: %d" % [GameState.gold, total]
	stats.add_theme_font_size_override("font_size", 20)
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(stats)
	
	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)
	
	var restart_button: Button = Button.new()
	restart_button.text = "Reiniciar"
	restart_button.custom_minimum_size = Vector2(200, 40)
	restart_button.pressed.connect(_on_restart_pressed)
	vbox.add_child(restart_button)

func _on_restart_pressed() -> void:
	GameState.reset_state()
	TransitionManager.go_to_scene("surface")

func _update_hud_battery() -> void:
	var hud: CanvasLayer = get_tree().current_scene.get_node_or_null("HUD")
	if hud and hud.has_method("update_battery"):
		hud.update_battery(flashlight_battery)
