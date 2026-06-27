extends StaticBody3D
class_name NPC

## ─── Señales ──────────────────────────────────────────
signal interaction_started(npc: NPC)
signal interaction_ended(npc: NPC)
signal trade_requested(npc: NPC)
signal shop_requested(npc: NPC)

## ─── Configuración ───────────────────────────────────
@export var npc_name: String = "Comprador"
@export var dialogue_lines: Array[String] = [
	"Bienvenido a la mina.",
	"Tengo lo que necesitas.",
	"¿Qué llevas en tu mochila?"
]

## ─── Estado ───────────────────────────────────────────
var is_player_near: bool = false
var current_dialogue_index: int = 0
var is_trade_open: bool = false
var is_shop_open: bool = false

## ─── Nodos ────────────────────────────────────────────
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var interaction_area: Area3D = $InteractionArea
@onready var dialogue_label: Label3D = $DialogueLabel
@onready var interact_hint: Label3D = $InteractHint

## ─── Paneles instanciados dinámicamente ──────────────
var _trade_layer: CanvasLayer = null
var _shop_layer: CanvasLayer = null
var _trade_panel: Control = null
var _shop_panel: Control = null

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	if dialogue_label:
		dialogue_label.visible = false
		dialogue_label.text = npc_name
	if interact_hint:
		interact_hint.visible = false
	_setup_mesh()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_near:
		if is_trade_open:
			_close_trade()
		elif is_shop_open:
			_close_shop()
		else:
			_interact()
	elif event.is_action_pressed("ui_cancel") and (is_trade_open or is_shop_open):
		_close_trade()
		_close_shop()

## ─── Métodos Públicos ─────────────────────────────────
func _interact() -> void:
	if dialogue_label:
		dialogue_label.visible = true
		dialogue_label.text = dialogue_lines[current_dialogue_index]
		current_dialogue_index = (current_dialogue_index + 1) % dialogue_lines.size()
		interaction_started.emit(self)
		
		get_tree().create_timer(2.0).timeout.connect(func():
			if dialogue_label and not is_trade_open and not is_shop_open:
				dialogue_label.visible = false
		)
		
		get_tree().create_timer(1.5).timeout.connect(func():
			if is_player_near and not is_trade_open and not is_shop_open:
				_open_trade()
		)

func _open_trade() -> void:
	is_trade_open = true
	_trade_layer = CanvasLayer.new()
	_trade_layer.layer = 20
	get_tree().current_scene.add_child(_trade_layer)
	
	var panel_scene: PackedScene = load("res://scenes/ui/trade_panel.tscn")
	_trade_panel = panel_scene.instantiate()
	_trade_layer.add_child(_trade_panel)
	_trade_panel.visible = true
	_trade_panel.trade_closed.connect(_on_trade_closed)
	trade_requested.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_toggle_pause"):
		player.is_paused = true
		player.velocity = Vector3.ZERO

func _close_trade() -> void:
	is_trade_open = false
	if _trade_panel:
		_trade_panel.visible = false
	if _trade_layer:
		_trade_layer.queue_free()
		_trade_layer = null
		_trade_panel = null
	interaction_ended.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_toggle_pause"):
		player.is_paused = false

func _on_trade_closed() -> void:
	_close_trade()

func _open_shop() -> void:
	is_shop_open = true
	_shop_layer = CanvasLayer.new()
	_shop_layer.layer = 20
	get_tree().current_scene.add_child(_shop_layer)
	
	var panel_scene: PackedScene = load("res://scenes/ui/shop_panel.tscn")
	_shop_panel = panel_scene.instantiate()
	_shop_layer.add_child(_shop_panel)
	_shop_panel.visible = true
	_shop_panel.shop_closed.connect(_on_shop_closed)
	shop_requested.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_toggle_pause"):
		player.is_paused = true
		player.velocity = Vector3.ZERO

func _close_shop() -> void:
	is_shop_open = false
	if _shop_panel:
		_shop_panel.visible = false
	if _shop_layer:
		_shop_layer.queue_free()
		_shop_layer = null
		_shop_panel = null
	interaction_ended.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if player and player.has_method("_toggle_pause"):
		player.is_paused = false

func _on_shop_closed() -> void:
	_close_shop()

func _setup_mesh() -> void:
	if mesh == null:
		return
	var glb_path: String = "res://assets/3d/characters/glb/Knight.glb"
	var glb_scene: PackedScene = load(glb_path)
	if glb_scene:
		var instance: Node3D = glb_scene.instantiate()
		for child in instance.get_children():
			instance.remove_child(child)
			mesh.add_child(child)
			if child is MeshInstance3D:
				mesh.mesh = child.mesh

func get_info() -> Dictionary:
	return {
		"name": npc_name,
		"dialogue_index": current_dialogue_index,
		"trade_open": is_trade_open,
		"shop_open": is_shop_open
	}

## ─── Señales de Área ──────────────────────────────────
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_near = true
		if interact_hint:
			interact_hint.visible = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_near = false
		if dialogue_label:
			dialogue_label.visible = false
		if interact_hint:
			interact_hint.visible = false
		if is_trade_open:
			_close_trade()
		if is_shop_open:
			_close_shop()
