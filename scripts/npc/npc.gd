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
@onready var trade_panel: Control = $TradePanel
@onready var shop_panel: Control = $ShopPanel

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	if dialogue_label:
		dialogue_label.visible = false
		dialogue_label.text = npc_name
	if trade_panel:
		trade_panel.visible = false
	if shop_panel:
		shop_panel.visible = false

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
		
		get_tree().create_timer(1.0).timeout.connect(func():
			if is_player_near and not is_trade_open and not is_shop_open:
				_open_trade()
		)

func _open_trade() -> void:
	is_trade_open = true
	if trade_panel:
		trade_panel.visible = true
		trade_requested.emit(self)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _close_trade() -> void:
	is_trade_open = false
	if trade_panel:
		trade_panel.visible = false
	interaction_ended.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _open_shop() -> void:
	is_shop_open = true
	if shop_panel:
		shop_panel.visible = true
		shop_requested.emit(self)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _close_shop() -> void:
	is_shop_open = false
	if shop_panel:
		shop_panel.visible = false
	interaction_ended.emit(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_near = false
		if dialogue_label:
			dialogue_label.visible = false
		if is_trade_open:
			_close_trade()
		if is_shop_open:
			_close_shop()
