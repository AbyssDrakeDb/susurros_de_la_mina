@tool
extends Node3D

## CavePreview - Preview con assets reales en editor
##
## Instances modular_caves.glb, dungeon floors/walls, y crystal minerals
## para ver exactamente como se vera el nivel en el juego.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate

var _generated_children: Array[Node] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

const CAVES_PATH: String = "res://assets/3d/environment/modular_caves.glb"
const FLOOR_PATH: String = "res://assets/3d/environment/dungeon/floors/floor_tile_large.gltf"
const WALL_PATH: String = "res://assets/3d/environment/dungeon/walls/wall.gltf"
const CRYSTAL_PATH: String = "res://assets/3d/minerals/Crystal.glb"

const BIOME_MINERALS: Dictionary = {
	1: ["copper", "iron"], 2: ["copper", "iron"], 3: ["copper", "iron"],
	4: ["silver", "crystal"], 5: ["silver", "crystal"],
	6: ["gold"], 7: ["gold"],
	8: ["crystal"], 9: ["crystal"], 10: ["crystal"],
}

const MINERAL_TINT: Dictionary = {
	"copper": Color(0.8, 0.4, 0.2),
	"iron": Color(0.5, 0.5, 0.55),
	"silver": Color(0.8, 0.8, 0.9),
	"gold": Color(1.0, 0.84, 0.0),
	"crystal": Color(0.4, 0.8, 1.0),
}

const BIOME_NAMES: Dictionary = {
	0: "Superficie", 1: "Somero", 2: "Somero", 3: "Somero",
	4: "Cristalino", 5: "Cristalino", 6: "Abandonado", 7: "Abandonado",
	8: "Profundo", 9: "Profundo", 10: "Maldito",
}

func _set_preview_depth(value: int) -> void:
	preview_depth = clampi(value, 0, 10)
	if auto_generate and Engine.is_editor_hint():
		generate()

func _set_auto_generate(value: bool) -> void:
	auto_generate = value
	if auto_generate and Engine.is_editor_hint():
		generate()

func generate() -> void:
	if not Engine.is_editor_hint():
		return
	_clear()
	_rng.seed = preview_depth * 7919 + 31337
	
	var biome_name: String = BIOME_NAMES.get(preview_depth, "?")
	_add_label(Vector3(0, 10, 0), "BIOMA: %s (Depth %d)" % [biome_name, preview_depth], Color.WHITE, 48)
	
	var room_count: int = _rng.randi_range(2, 4)
	var room_spacing: float = 25.0
	
	var room_positions: Array[Vector3] = []
	for i in range(room_count):
		var offset: float = (i - room_count / 2.0) * room_spacing
		var pos: Vector3 = Vector3(offset, 0.0, -i * room_spacing)
		room_positions.append(pos)
		_build_room(pos, i)
	
	for i in range(1, room_positions.size()):
		_build_tunnel(room_positions[i - 1], room_positions[i], i - 1)
	
	_build_compass(Vector3(room_spacing, 12, 0))

func clear_editor() -> void:
	_clear()

func _clear() -> void:
	for child in _generated_children:
		if child != null and is_instance_valid(child):
			child.queue_free()
	_generated_children.clear()

func _add_label(pos: Vector3, text: String, color: Color, size: int = 24) -> void:
	var label: Label3D = Label3D.new()
	label.position = pos
	label.text = text
	label.font_size = size
	label.modulate = color
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	add_child(label)
	if owner:
		label.owner = owner
	_generated_children.append(label)

func _build_room(pos: Vector3, index: int) -> void:
	var room_root: Node3D = Node3D.new()
	room_root.name = "Room_%d" % index
	room_root.position = pos
	add_child(room_root)
	if owner:
		room_root.owner = owner
	_generated_children.append(room_root)
	
	_add_label(pos + Vector3(0, 8, 0), "SALA %d" % index, Color.YELLOW, 36)
	
	_instance_cave_mesh(room_root, Vector3.ZERO)
	_instance_floor(room_root, Vector3(0, -2.5, 0))
	_instance_walls(room_root)
	_instance_minerals(room_root)

func _instance_cave_mesh(parent: Node3D, offset: Vector3) -> void:
	var caves_scene: PackedScene = load(CAVES_PATH) as PackedScene
	if caves_scene == null:
		return
	var caves: Node3D = caves_scene.instantiate() as Node3D
	if caves == null:
		return
	caves.position = offset
	parent.add_child(caves)
	if owner:
		caves.owner = owner
	_generated_children.append(caves)

func _instance_floor(parent: Node3D, offset: Vector3) -> void:
	var floor_scene: PackedScene = load(FLOOR_PATH) as PackedScene
	if floor_scene == null:
		return
	var floor_inst: Node3D = floor_scene.instantiate() as Node3D
	if floor_inst == null:
		return
	floor_inst.position = offset
	parent.add_child(floor_inst)
	if owner:
		floor_inst.owner = owner
	_generated_children.append(floor_inst)
	
	var floor_inst2: Node3D = floor_scene.instantiate() as Node3D
	floor_inst2.position = offset + Vector3(4, 0, 0)
	parent.add_child(floor_inst2)
	if owner:
		floor_inst2.owner = owner
	_generated_children.append(floor_inst2)
	
	var floor_inst3: Node3D = floor_scene.instantiate() as Node3D
	floor_inst3.position = offset + Vector3(-4, 0, 0)
	parent.add_child(floor_inst3)
	if owner:
		floor_inst3.owner = owner
	_generated_children.append(floor_inst3)

func _instance_walls(parent: Node3D) -> void:
	var wall_scene: PackedScene = load(WALL_PATH) as PackedScene
	if wall_scene == null:
		return
	
	var wall_positions: Array[Vector3] = [
		Vector3(6, 0, 0), Vector3(-6, 0, 0),
		Vector3(0, 0, 6), Vector3(0, 0, -6),
		Vector3(6, 0, 6), Vector3(-6, 0, 6),
		Vector3(6, 0, -6), Vector3(-6, 0, -6),
	]
	
	for wpos in wall_positions:
		var wall: Node3D = wall_scene.instantiate() as Node3D
		if wall == null:
			continue
		wall.position = wpos
		parent.add_child(wall)
		if owner:
			wall.owner = owner
		_generated_children.append(wall)

func _instance_minerals(parent: Node3D) -> void:
	var mineral_types: Array = BIOME_MINERALS.get(preview_depth, ["copper"])
	var crystal_scene: PackedScene = load(CRYSTAL_PATH) as PackedScene
	
	var mineral_count: int = _rng.randi_range(3, 6)
	for i in range(mineral_count):
		var mineral_type: String = mineral_types[_rng.randi() % mineral_types.size()]
		var mineral_pos: Vector3 = Vector3(
			_rng.randf_range(-4.0, 4.0),
			-1.0,
			_rng.randf_range(-4.0, 4.0)
		)
		
		if crystal_scene != null:
			var crystal: Node3D = crystal_scene.instantiate() as Node3D
			if crystal != null:
				crystal.position = mineral_pos
				crystal.scale = Vector3(0.5, 0.5, 0.5)
				parent.add_child(crystal)
				if owner:
					crystal.owner = owner
				_generated_children.append(crystal)
		
		var marker: Label3D = Label3D.new()
		marker.position = mineral_pos + Vector3(0, 1.5, 0)
		marker.text = mineral_type
		marker.font_size = 16
		marker.modulate = MINERAL_TINT.get(mineral_type, Color.WHITE)
		marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		marker.no_depth_test = true
		parent.add_child(marker)
		if owner:
			marker.owner = owner
		_generated_children.append(marker)

func _build_tunnel(from_pos: Vector3, to_pos: Vector3, index: int) -> void:
	var tunnel_root: Node3D = Node3D.new()
	tunnel_root.name = "Tunnel_%d" % index
	tunnel_root.position = (from_pos + to_pos) / 2.0
	add_child(tunnel_root)
	if owner:
		tunnel_root.owner = owner
	_generated_children.append(tunnel_root)
	
	var direction: Vector3 = (to_pos - from_pos).normalized()
	var distance: float = from_pos.distance_to(to_pos)
	
	_add_label(tunnel_root.position + Vector3(0, 5, 0), "TUNNEL %d (%.0fm)" % [index, distance], Color.CYAN, 28)
	
	var up: Vector3 = Vector3.UP
	var right: Vector3 = direction.cross(up).normalized()
	if right.length() < 0.001:
		right = Vector3.FORWARD
	var real_up: Vector3 = right.cross(direction).normalized()
	
	var segment_count: int = int(distance / 4.0)
	segment_count = maxi(segment_count, 2)
	
	for s in range(segment_count):
		var t: float = float(s) / float(segment_count - 1) - 0.5
		var seg_pos: Vector3 = direction * t * distance
		
		var cave_scene: PackedScene = load(CAVES_PATH) as PackedScene
		if cave_scene != null:
			var cave_piece: Node3D = cave_scene.instantiate() as Node3D
			if cave_piece != null:
				cave_piece.position = seg_pos
				tunnel_root.add_child(cave_piece)
				if owner:
					cave_piece.owner = owner
				_generated_children.append(cave_piece)

func _build_compass(pos: Vector3) -> void:
	_add_label(pos + Vector3(0, 0, -4), "N", Color.RED, 40)
	_add_label(pos + Vector3(0, 0, 4), "S", Color.WHITE, 40)
	_add_label(pos + Vector3(4, 0, 0), "E", Color.WHITE, 40)
	_add_label(pos + Vector3(-4, 0, 0), "O", Color.WHITE, 40)
	_add_label(pos, "ORIGEN", Color.GREEN, 32)
