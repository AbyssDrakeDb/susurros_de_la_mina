extends Node3D

## ─── Configuración ───────────────────────────────────
@export var clear_hand_crafted: bool = true

## ─── Nodos a gestionar ───────────────────────────────
@onready var minerals_node: Node3D = $Minerals if has_node("Minerals") else null
@onready var hazards_node: Node3D = $Hazards if has_node("Hazards") else null
@onready var pickups_node: Node3D = $Pickups if has_node("Pickups") else null

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_setup_procedural_generation()

## ─── Métodos Privados ─────────────────────────────────
func _setup_procedural_generation() -> void:
	if clear_hand_crafted:
		_clear_hand_crafted_content()
	
	var chunks_container: Node3D = Node3D.new()
	chunks_container.name = "Chunks"
	add_child(chunks_container)
	
	MineGenerator.setup(chunks_container)
	
	if GameState.current_depth > 0:
		MineGenerator.chunk_manager._update_visible_chunks()

func _clear_hand_crafted_content() -> void:
	if minerals_node != null:
		minerals_node.queue_free()
		minerals_node = null
	
	if hazards_node != null:
		hazards_node.queue_free()
		hazards_node = null
	
	if pickups_node != null:
		pickups_node.queue_free()
		pickups_node = null
