@tool
extends Node3D

## CavePreview - Replica el patrón de cave_example.tscn
##
## Usa meshes de modular_caves.glb para crear un camino serpenteante
## que desciende 10 niveles de profundidad, como el original.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate

var _generated: Array[Node] = []
var _mesh_pool: Array[Mesh] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

const CAVE_SCENE: String = "res://assets/3d/environment/modular_caves.glb"

const BIOME_NAMES := {
	0: "Superficie", 1: "Somero", 2: "Somero", 3: "Somero",
	4: "Cristalino", 5: "Cristalino", 6: "Abandonado", 7: "Abandonado",
	8: "Profundo", 9: "Profundo", 10: "Maldito",
}

const BIOME_COLORS := {
	0: Color(0.3, 0.8, 0.2), 1: Color(0.6, 0.5, 0.3), 2: Color(0.6, 0.5, 0.3),
	3: Color(0.6, 0.5, 0.3), 4: Color(0.4, 0.7, 1.0), 5: Color(0.4, 0.7, 1.0),
	6: Color(0.5, 0.4, 0.3), 7: Color(0.5, 0.4, 0.3), 8: Color(0.3, 0.3, 0.4),
	9: Color(0.3, 0.3, 0.4), 10: Color(0.6, 0.1, 0.1),
}

const BIOME_MINERALS := {
	1: ["Cobre", "Hierro"], 2: ["Cobre", "Hierro"], 3: ["Cobre", "Hierro"],
	4: ["Plata", "Cristal"], 5: ["Plata", "Cristal"],
	6: ["Oro"], 7: ["Oro"], 8: ["Cristal"], 9: ["Cristal"], 10: ["Cristal"],
}

const MINERAL_TINT := {
	"Cobre": Color(0.8, 0.4, 0.2), "Hierro": Color(0.5, 0.5, 0.55),
	"Plata": Color(0.8, 0.8, 0.9), "Oro": Color(1.0, 0.84, 0.0),
	"Cristal": Color(0.4, 0.8, 1.0),
}

func _set_preview_depth(v: int) -> void:
	preview_depth = clampi(v, 0, 10)
	if auto_generate and Engine.is_editor_hint():
		generate()

func _set_auto_generate(v: bool) -> void:
	auto_generate = v
	if auto_generate and Engine.is_editor_hint():
		generate()

func generate() -> void:
	if not Engine.is_editor_hint():
		return
	_clear()
	_mesh_pool.clear()
	_collect_meshes()
	_rng.seed = preview_depth * 7919 + 31337
	
	var biome: String = BIOME_NAMES.get(preview_depth, "?")
	_label(Vector3(0, 10, 0), "BIOMA: %s (Depth %d)" % [biome, preview_depth], Color.WHITE, 48)
	
	var level_count: int = clampi(preview_depth, 1, 10) if preview_depth > 0 else 1
	var positions: Array[Dictionary] = _calculate_path(level_count)
	
	for i in range(positions.size()):
		var pos: Vector3 = positions[i]["pos"]
		var level: int = positions[i]["level"]
		var is_room: bool = positions[i].get("room", false)
		var is_turn: bool = positions[i].get("turn", false)
		
		_place_cave_mesh(pos, level, is_room, is_turn)
		
		if i > 0:
			_draw_connection(positions[i - 1]["pos"], pos, positions[i - 1]["level"])
	
	_label(Vector3(-10, 10, 0), "N", Color.RED, 36)
	_label(Vector3(10, 10, 0), "S", Color.WHITE, 36)
	_label(Vector3(0, 10, -10), "E", Color.WHITE, 36)
	_label(Vector3(0, 10, 10), "W", Color.WHITE, 36)

func clear_editor() -> void:
	_clear()

func _clear() -> void:
	for n in _generated:
		if n and is_instance_valid(n):
			n.queue_free()
	_generated.clear()

func _collect_meshes() -> void:
	var scene: PackedScene = load(CAVE_SCENE) as PackedScene
	if scene == null:
		return
	var instance: Node = scene.instantiate()
	if instance == null:
		return
	add_child(instance)
	_collect_meshes_recursive(instance, _mesh_pool)
	remove_child(instance)
	instance.free()

func _collect_meshes_recursive(node: Node, pool: Array[Mesh]) -> void:
	if node is MeshInstance3D:
		var mi: MeshInstance3D = node as MeshInstance3D
		if mi.mesh != null and mi.mesh not in pool:
			pool.append(mi.mesh)
	for child in node.get_children():
		_collect_meshes_recursive(child, pool)

func _calculate_path(level_count: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var spacing_z: float = 300.0
	var meander_x: float = 200.0
	var drop_y: float = 250.0
	
	for level in range(level_count + 1):
		var z: float = -level * spacing_z
		var x: float = sin(level * 1.2) * meander_x
		var y: float = -level * drop_y
		
		result.append({"pos": Vector3(x, y, z), "level": level, "room": true})
		
		if level < level_count:
			var mid_z: float = z - spacing_z * 0.5
			var mid_x: float = (x + sin((level + 1) * 1.2) * meander_x) * 0.5
			var mid_y: float = y - drop_y * 0.5
			result.append({"pos": Vector3(mid_x, mid_y, mid_z), "level": level, "turn": true})
	
	return result

func _place_cave_mesh(pos: Vector3, level: int, is_room: bool, is_turn: bool) -> void:
	if _mesh_pool.is_empty():
		return
	
	var mesh_idx: int = (level * 3 + (1 if is_room else 0) + (2 if is_turn else 0)) % _mesh_pool.size()
	var mesh: Mesh = _mesh_pool[mesh_idx]
	
	var mi: MeshInstance3D = MeshInstance3D.new()
	mi.mesh = mesh
	mi.position = pos
	add_child(mi)
	if owner:
		mi.owner = owner
	_generated.append(mi)
	
	var biome: String = BIOME_NAMES.get(level, "?")
	var room_type: String = "SALA" if is_room else "TUNEL"
	var biome_color: Color = BIOME_COLORS.get(level, Color.WHITE)
	
	if is_room:
		_label(pos + Vector3(0, 15, 0), "%s Nivel %d\n%s" % [room_type, level, biome], biome_color, 28)
		
		var minerals: Array = BIOME_MINERALS.get(level, [])
		if not minerals.is_empty():
			var mineral_count: int = _rng.randi_range(2, 4)
			for i in range(mineral_count):
				var mtype: String = minerals[_rng.randi() % minerals.size()]
				var offset: Vector3 = Vector3(
					_rng.randf_range(-30, 30),
					_rng.randf_range(-5, 5),
					_rng.randf_range(-30, 30)
				)
				var mlabel: Label3D = Label3D.new()
				mlabel.position = pos + offset + Vector3(0, 8, 0)
				mlabel.text = mtype
				mlabel.font_size = 16
				mlabel.modulate = MINERAL_TINT.get(mtype, Color.WHITE)
				mlabel.billboard = BaseMaterial3D.BILLBOARD_ENABLED
				mlabel.no_depth_test = true
				add_child(mlabel)
				if owner:
					mlabel.owner = owner
				_generated.append(mlabel)
	else:
		_label(pos + Vector3(0, 10, 0), "TUNEL\n%.0fm" % pos.length(), Color.CYAN, 18)

func _draw_connection(from: Vector3, to: Vector3, level: int) -> void:
	var dir: Vector3 = (to - from).normalized()
	var dist: float = from.distance_to(to)
	var segments: int = int(dist / 150.0)
	segments = maxi(segments, 1)
	
	for s in range(segments):
		var t: float = float(s) / float(segments)
		var p: Vector3 = from.lerp(to, t)
		
		if _mesh_pool.is_empty():
			continue
		
		var conn_mesh: Mesh = _mesh_pool[(level * 7 + s) % _mesh_pool.size()]
		var conn_mi: MeshInstance3D = MeshInstance3D.new()
		conn_mi.mesh = conn_mesh
		conn_mi.position = p
		add_child(conn_mi)
		if owner:
			conn_mi.owner = owner
		_generated.append(conn_mi)

func _label(pos: Vector3, text: String, color: Color, size: int = 24) -> void:
	var l: Label3D = Label3D.new()
	l.position = pos
	l.text = text
	l.font_size = size
	l.modulate = color
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.no_depth_test = true
	add_child(l)
	if owner:
		l.owner = owner
	_generated.append(l)
