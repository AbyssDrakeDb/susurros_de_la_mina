extends Node
class_name MineGeneratorClass

## ─── Configuración ───────────────────────────────────
@export var chunk_size: int = 50
@export var render_distance: int = 2
@export var mine_depth: int = 10

## ─── Sub-sistemas ────────────────────────────────────
var biome_selector: BiomeSelectorClass
var room_spawner: RoomSpawnerClass
var mineral_spawner: MineralSpawnerClass
var hazard_spawner: HazardSpawnerClass
var chunk_manager: ChunkManagerClass

## ─── Estado ──────────────────────────────────────────
var current_depth: int = 0
var generated_chunks: Dictionary = {}
var is_initialized: bool = false

## ─── RNG ─────────────────────────────────────────────
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

## ─── Señales ──────────────────────────────────────────
signal chunk_generated(depth: int)
signal chunk_unloaded(depth: int)
signal biome_changed(biome: BiomeResource)

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	_setup_subsystems()
	GameState.depth_changed.connect(_on_depth_changed)
	is_initialized = true

func _setup_subsystems() -> void:
	biome_selector = BiomeSelectorClass.new()
	biome_selector.name = "BiomeSelector"
	add_child(biome_selector)
	
	room_spawner = RoomSpawnerClass.new()
	room_spawner.name = "RoomSpawner"
	add_child(room_spawner)
	
	mineral_spawner = MineralSpawnerClass.new()
	mineral_spawner.name = "MineralSpawner"
	add_child(mineral_spawner)
	
	hazard_spawner = HazardSpawnerClass.new()
	hazard_spawner.name = "HazardSpawner"
	add_child(hazard_spawner)
	
	chunk_manager = ChunkManagerClass.new()
	chunk_manager.name = "ChunkManager"
	add_child(chunk_manager)
	chunk_manager.initialize(self)

## ─── Métodos Públicos ────────────────────────────────
func generate_chunk(depth: int) -> Node3D:
	_rng.seed = _get_chunk_seed(depth)
	
	var chunk: Node3D = Node3D.new()
	chunk.name = "Chunk_%d" % depth
	
	var biome: BiomeResource = biome_selector.get_biome_at_depth(depth)
	
	var room_count: int = _rng.randi_range(2, 4)
	var room_spacing: float = chunk_size / float(room_count)
	
	var last_room: Node3D = null
	
	for i in range(room_count):
		var template: RoomTemplate = _pick_room_template(biome, depth)
		var offset: float = (i - room_count / 2.0) * room_spacing
		var room_pos: Vector3 = Vector3(offset, 0.0, -depth * chunk_size)
		
		var room: Node3D = room_spawner.spawn_room(template, room_pos, chunk)
		if room == null:
			continue
		
		mineral_spawner.spawn_minerals_in_room(room, biome)
		hazard_spawner.spawn_hazards_in_room(room, biome)
		
		if last_room != null:
			room_spawner.connect_rooms(last_room, room, biome.tunnel_scene if biome else null)
		
		last_room = room
	
	chunk_generated.emit(depth)
	return chunk

func get_biome_at_depth(depth: int) -> BiomeResource:
	return biome_selector.get_biome_at_depth(depth)

func get_room_for_depth(depth: int) -> RoomTemplate:
	var biome: BiomeResource = biome_selector.get_biome_at_depth(depth)
	return _pick_room_template(biome, depth)

func spawn_minerals(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
	return mineral_spawner.spawn_minerals_in_room(room, biome)

func spawn_hazards(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
	return hazard_spawner.spawn_hazards_in_room(room, biome)

func get_generated_count() -> int:
	return chunk_manager.get_generated_count()

func clear_all_chunks() -> void:
	chunk_manager.clear_all()

func set_chunk_container(container: Node3D) -> void:
	chunk_manager.set_chunk_container(container)

## ─── Métodos Privados ────────────────────────────────
func _get_chunk_seed(depth: int) -> int:
	return depth * 7919 + 31337

func _pick_room_template(biome: BiomeResource, depth: int) -> RoomTemplate:
	if biome == null or biome.room_scenes.is_empty():
		return _create_fallback_template(depth)
	
	var valid_rooms: Array[PackedScene] = []
	for scene in biome.room_scenes:
		if scene != null:
			valid_rooms.append(scene)
	
	if valid_rooms.is_empty():
		return _create_fallback_template(depth)
	
	var template: RoomTemplate = RoomTemplate.new()
	template.room_id = "room_%d_%d" % [depth, _rng.randi()]
	template.scene = valid_rooms[_rng.randi() % valid_rooms.size()]
	template.biome = biome
	template.min_depth = biome.depth_min
	template.max_depth = biome.depth_max
	return template

func _create_fallback_template(depth: int) -> RoomTemplate:
	var template: RoomTemplate = RoomTemplate.new()
	template.room_id = "fallback_%d" % depth
	template.scene = preload("res://scenes/environment/cave_room.tscn")
	template.min_depth = 0
	template.max_depth = 10
	template.weight = 1.0
	return template

func _on_depth_changed(new_depth: int) -> void:
	current_depth = new_depth
	var biome: BiomeResource = biome_selector.get_biome_at_depth(new_depth)
	if biome != null:
		biome_changed.emit(biome)
