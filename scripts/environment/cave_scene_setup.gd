extends Node3D

## ─── Configuración ───────────────────────────────────
@export var clear_hand_crafted: bool = true

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_setup_procedural_generation()

## ─── Métodos Privados ─────────────────────────────────
func _setup_procedural_generation() -> void:
	if clear_hand_crafted:
		_clear_hand_crafted_content()
	
	if has_node("Chunks"):
		get_node("Chunks").queue_free()
		await get_tree().process_frame
	
	var chunks_container: Node3D = Node3D.new()
	chunks_container.name = "Chunks"
	add_child(chunks_container)
	
	MineGenerator.setup(chunks_container)
	MineGenerator.clear_all_chunks()
	
	if GameState.current_depth > 0:
		MineGenerator.chunk_manager._update_visible_chunks()

func _clear_hand_crafted_content() -> void:
	for node_name in ["Minerals", "Hazards", "Pickups"]:
		var node: Node3D = get_node_or_null(node_name)
		if node != null:
			node.queue_free()
