extends Node
class_name ChunkManagerClass

## ─── Configuración ───────────────────────────────────
@export var chunk_size: int = 30
@export var render_distance: int = 2

## ─── Estado ──────────────────────────────────────────
var current_depth: int = 0
var generated_chunks: Dictionary = {}
var chunk_container: Node3D = null

## ─── Referencias ─────────────────────────────────────
var _mine_generator: Node = null

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	GameState.depth_changed.connect(_on_depth_changed)

func initialize(gen: Node) -> void:
	_mine_generator = gen

## ─── Métodos Públicos ────────────────────────────────
func set_chunk_container(container: Node3D) -> void:
	chunk_container = container

func _is_container_valid() -> bool:
	return chunk_container != null and is_instance_valid(chunk_container) and chunk_container.is_inside_tree()

func get_chunk_key(depth: int) -> String:
	return "chunk_%d" % depth

func is_chunk_generated(depth: int) -> bool:
	return generated_chunks.has(get_chunk_key(depth))

func get_chunk(depth: int) -> Node3D:
	var key: String = get_chunk_key(depth)
	if generated_chunks.has(key):
		var chunk: Node3D = generated_chunks[key]
		if chunk != null and is_instance_valid(chunk):
			return chunk
		generated_chunks.erase(key)
	return null

func generate_chunk_at_depth(depth: int) -> Node3D:
	if is_chunk_generated(depth):
		return get_chunk(depth)
	
	if _mine_generator == null:
		push_error("ChunkManager: MineGenerator no inicializado")
		return null
	
	if not _is_container_valid():
		return null
	
	var chunk: Node3D = _mine_generator.generate_chunk(depth, chunk_container)
	if chunk == null:
		return null
	
	var key: String = get_chunk_key(depth)
	generated_chunks[key] = chunk
	
	return chunk

func unload_chunk(depth: int) -> void:
	var key: String = get_chunk_key(depth)
	if not generated_chunks.has(key):
		return
	
	var chunk: Node3D = generated_chunks[key]
	if chunk != null and is_instance_valid(chunk):
		chunk.queue_free()
	
	generated_chunks.erase(key)

func unload_distant_chunks() -> void:
	var keys_to_remove: Array[String] = []
	
	for key in generated_chunks.keys():
		var depth: int = key.replace("chunk_", "").to_int()
		if abs(depth - current_depth) > render_distance:
			keys_to_remove.append(key)
	
	for key in keys_to_remove:
		var depth: int = key.replace("chunk_", "").to_int()
		unload_chunk(depth)

func get_generated_count() -> int:
	return generated_chunks.size()

func clear_all() -> void:
	for key in generated_chunks.keys():
		var chunk: Node3D = generated_chunks[key]
		if chunk != null and is_instance_valid(chunk):
			chunk.queue_free()
	generated_chunks.clear()

## ─── Métodos Privados ────────────────────────────────
func _on_depth_changed(new_depth: int) -> void:
	current_depth = new_depth
	_update_visible_chunks()

func _update_visible_chunks() -> void:
	if not _is_container_valid():
		return
	
	for d in range(current_depth - render_distance, current_depth + render_distance + 1):
		if d >= 0 and d <= 10 and not is_chunk_generated(d):
			generate_chunk_at_depth(d)
	
	unload_distant_chunks()
