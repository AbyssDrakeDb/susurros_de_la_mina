extends Node

## DebugCamera - Modo vuelo libre para debug
##
## Presiona F5 para activar/desactivar.
## WASD + Mouse para mover, Shift para acelerar.
## Agrega iluminación ambiental al activar.

var is_active: bool = false
var fly_speed: float = 15.0
var fast_speed: float = 40.0
var mouse_sensitivity: float = 0.002

var _camera: Camera3D = null
var _player: CharacterBody3D = null
var _debug_light: DirectionalLight3D = null
var _env: Environment = null
var _original_ambient_energy: float = 0.0
var _mouse_motion: Vector2 = Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F5:
		_toggle_debug()
		get_viewport().set_input_as_handled()
		return
	
	if is_active and event is InputEventMouseMotion:
		_mouse_motion = event.relative

func _process(delta: float) -> void:
	if not is_active:
		return
	
	if _camera == null:
		return
	
	_handle_mouse_input()
	_handle_keyboard_input(delta)
	_mouse_motion = Vector2.ZERO

func _handle_mouse_input() -> void:
	if _mouse_motion.length() < 0.001:
		return
	
	_camera.rotate_y(-_mouse_motion.x * mouse_sensitivity)
	_camera.rotate_object_local(Vector3.RIGHT, -_mouse_motion.y * mouse_sensitivity)
	_camera.rotation.x = clampf(_camera.rotation.x, -PI / 2.0, PI / 2.0)

func _handle_keyboard_input(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var speed: float = fast_speed if Input.is_action_pressed("sprint") else fly_speed
	
	var direction: Vector3 = Vector3.ZERO
	direction += _camera.global_basis.z * input_dir.y
	direction += _camera.global_basis.x * input_dir.x
	
	if Input.is_action_pressed("jump"):
		direction += Vector3.UP
	if Input.is_action_pressed("open_inventory"):
		direction -= Vector3.UP
	
	if direction.length() > 0.001:
		direction = direction.normalized()
		_camera.global_position += direction * speed * delta

func _toggle_debug() -> void:
	is_active = not is_active
	
	if is_active:
		_activate()
	else:
		_deactivate()

func _activate() -> void:
	_player = _find_player()
	_camera = _find_camera()
	
	if _player != null:
		_player.set_physics_process(false)
		_player.set_process(false)
		_player.velocity = Vector3.ZERO
	
	if _camera != null:
		_camera.current = true
	
	_add_debug_light()
	_add_ambient_light()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _deactivate() -> void:
	if _player != null:
		_player.set_physics_process(true)
		_player.set_process(true)
		_player.velocity = Vector3.ZERO
	
	if _camera != null and _player != null:
		_player.camera.current = true
	
	_remove_debug_light()
	_remove_ambient_light()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _find_player() -> CharacterBody3D:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as CharacterBody3D
	return null

func _find_camera() -> Camera3D:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var p: CharacterBody3D = players[0] as CharacterBody3D
		return p.get_node_or_null("Head/Camera3D") as Camera3D
	return null

func _add_debug_light() -> void:
	if _debug_light != null:
		return
	
	_debug_light = DirectionalLight3D.new()
	_debug_light.name = "DebugLight"
	_debug_light.light_energy = 1.5
	_debug_light.light_color = Color(1.0, 0.98, 0.95)
	_debug_light.shadow_enabled = false
	_debug_light.rotation_degrees = Vector3(-45, 30, 0)
	get_tree().current_scene.add_child(_debug_light)

func _remove_debug_light() -> void:
	if _debug_light != null:
		_debug_light.queue_free()
		_debug_light = null

func _add_ambient_light() -> void:
	var world_env: WorldEnvironment = get_tree().current_scene.get_node_or_null("WorldEnvironment")
	if world_env == null:
		world_env = WorldEnvironment.new()
		world_env.name = "DebugWorldEnvironment"
		get_tree().current_scene.add_child(world_env)
	
	_env = world_env.environment
	if _env != null:
		_original_ambient_energy = _env.ambient_light_energy
		_env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		_env.ambient_light_color = Color(0.4, 0.4, 0.45)
		_env.ambient_light_energy = 1.0
		_env.fog_light_color = Color(0.3, 0.3, 0.35)

func _remove_ambient_light() -> void:
	if _env != null:
		_env.ambient_light_energy = _original_ambient_energy
		_env = null
