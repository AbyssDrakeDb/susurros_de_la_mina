@tool
extends Node3D

## CavePreview - Previsualización de cueva en editor
##
## Agrega este script a un Node3D en el editor.
## Cambia preview_depth en el Inspector y presiona Generate.
## Usa el mismo sistema de MineGenerator sin depender de autoloads.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate

var _generated_children: Array[Node3D] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

const BIOME_DATA: Dictionary = {
	0: {"color": Color(0.9, 0.9, 0.8), "fog": Color(0.7, 0.8, 0.9)},
	1: {"color": Color(0.6, 0.55, 0.45), "fog": Color(0.3, 0.25, 0.2)},
	2: {"color": Color(0.6, 0.55, 0.45), "fog": Color(0.3, 0.25, 0.2)},
	3: {"color": Color(0.6, 0.55, 0.45), "fog": Color(0.3, 0.25, 0.2)},
	4: {"color": Color(0.4, 0.6, 0.9), "fog": Color(0.2, 0.4, 0.7)},
	5: {"color": Color(0.4, 0.6, 0.9), "fog": Color(0.2, 0.4, 0.7)},
	6: {"color": Color(0.4, 0.35, 0.3), "fog": Color(0.15, 0.12, 0.1)},
	7: {"color": Color(0.4, 0.35, 0.3), "fog": Color(0.15, 0.12, 0.1)},
	8: {"color": Color(0.15, 0.15, 0.2), "fog": Color(0.05, 0.05, 0.08)},
	9: {"color": Color(0.15, 0.15, 0.2), "fog": Color(0.05, 0.05, 0.08)},
	10: {"color": Color(0.4, 0.1, 0.6), "fog": Color(0.2, 0.05, 0.3)},
}

const MINERAL_COLORS: Dictionary = {
	"copper": Color(0.8, 0.4, 0.2),
	"iron": Color(0.5, 0.5, 0.55),
	"silver": Color(0.8, 0.8, 0.9),
	"gold": Color(1.0, 0.84, 0.0),
	"crystal": Color(0.4, 0.8, 1.0),
}

const BIOME_MINERALS: Dictionary = {
	1: ["copper", "iron"],
	2: ["copper", "iron"],
	3: ["copper", "iron"],
	4: ["silver", "crystal"],
	5: ["silver", "crystal"],
	6: ["gold"],
	7: ["gold"],
	8: ["crystal"],
	9: ["crystal"],
	10: ["crystal"],
}

func _set_preview_depth(value: int) -> void:
	preview_depth = clampi(value, 0, 10)
	if auto_generate and Engine.is_editor_hint():
		_generate_preview()

func _set_auto_generate(value: bool) -> void:
	auto_generate = value
	if auto_generate and Engine.is_editor_hint():
		_generate_preview()

func generate() -> void:
	if Engine.is_editor_hint():
		_generate_preview()

func clear() -> void:
	_clear_preview()

func _generate_preview() -> void:
	_clear_preview()
	_rng.seed = preview_depth * 7919 + 31337
	
	var room_count: int = _rng.randi_range(2, 4)
	var room_spacing: float = 15.0
	var chunk_origin: Vector3 = Vector3.ZERO
	
	for i in range(room_count):
		var offset: float = (i - room_count / 2.0) * room_spacing
		var room_pos: Vector3 = Vector3(offset, 0.0, -i * room_spacing)
		_create_room(room_pos, chunk_origin)
		_create_minerals(room_pos, chunk_origin)
		_create_floor(room_pos, chunk_origin)
		
		if i > 0:
			var prev_pos: Vector3 = Vector3((i - 1 - room_count / 2.0) * room_spacing, 0.0, -(i - 1) * room_spacing)
			_create_tunnel(prev_pos, room_pos, chunk_origin)
	
	_notify_property_list_changed()

func _clear_preview() -> void:
	for child in _generated_children:
		if child != null and is_instance_valid(child):
			child.queue_free()
	_generated_children.clear()

func _create_room(pos: Vector3, origin: Vector3) -> void:
	var room: Node3D = Node3D.new()
	room.name = "PreviewRoom_%d" % _generated_children.size()
	room.position = pos + origin
	add_child(room)
	room.owner = owner if owner else self
	_generated_children.append(room)
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var room_radius: float = 6.0
	var room_height: float = 5.0
	var segments: int = 12
	var rings: int = 4
	
	for i in range(rings + 1):
		var y: float = float(i) / float(rings) * room_height - room_height / 2.0
		var radius_at_y: float = room_radius * (1.0 - 0.3 * pow(float(i) / float(rings) - 0.5, 2.0))
		
		for j in range(segments):
			var angle_a: float = float(j) / float(segments) * TAU
			var angle_b: float = float(j + 1) / float(segments) * TAU
			
			var wobble_a: float = 0.85 + 0.15 * sin(float(i) * 2.1 + float(j) * 1.7)
			var wobble_b: float = 0.85 + 0.15 * sin(float(i) * 2.1 + float(j + 1) * 1.7)
			
			var p1: Vector3 = Vector3(cos(angle_a) * radius_at_y * wobble_a, y, sin(angle_a) * radius_at_y * wobble_a)
			var p2: Vector3 = Vector3(cos(angle_b) * radius_at_y * wobble_b, y, sin(angle_b) * radius_at_y * wobble_b)
			
			var next_y: float = float(i + 1) / float(rings) * room_height - room_height / 2.0
			var next_radius: float = room_radius * (1.0 - 0.3 * pow(float(i + 1) / float(rings) - 0.5, 2.0))
			var p3: Vector3 = Vector3(cos(angle_a) * next_radius * wobble_a, next_y, sin(angle_a) * next_radius * wobble_a)
			var p4: Vector3 = Vector3(cos(angle_b) * next_radius * wobble_b, next_y, sin(angle_b) * next_radius * wobble_b)
			
			st.add_vertex(p1)
			st.add_vertex(p2)
			st.add_vertex(p3)
			st.add_vertex(p2)
			st.add_vertex(p4)
			st.add_vertex(p3)
	
	var cave_mesh: ArrayMesh = st.commit()
	var mesh_inst: MeshInstance3D = MeshInstance3D.new()
	mesh_inst.mesh = cave_mesh
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = BIOME_DATA.get(preview_depth, BIOME_DATA[1])["color"]
	mat.roughness = 0.9
	mesh_inst.material_override = mat
	room.add_child(mesh_inst)
	mesh_inst.owner = room.owner
	
	var static_body: StaticBody3D = StaticBody3D.new()
	static_body.name = "CaveBody"
	static_body.collision_layer = 1
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	collision_shape.shape = cave_mesh.create_trimesh_shape()
	static_body.add_child(collision_shape)
	room.add_child(static_body)
	static_body.owner = room.owner

func _create_floor(pos: Vector3, origin: Vector3) -> void:
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "Floor"
	floor_body.position = pos + origin + Vector3(0, -2.5, 0)
	floor_body.collision_layer = 1
	add_child(floor_body)
	floor_body.owner = owner if owner else self
	_generated_children.append(floor_body)
	
	var floor_mesh_inst: MeshInstance3D = MeshInstance3D.new()
	var floor_box: BoxMesh = BoxMesh.new()
	floor_box.size = Vector3(12, 0.3, 12)
	floor_mesh_inst.mesh = floor_box
	var floor_mat: StandardMaterial3D = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.18, 0.16)
	floor_mesh_inst.material_override = floor_mat
	floor_body.add_child(floor_mesh_inst)
	floor_mesh_inst.owner = floor_body.owner
	
	var floor_shape: CollisionShape3D = CollisionShape3D.new()
	floor_shape.shape = BoxShape3D.new()
	floor_shape.shape.size = Vector3(12, 0.3, 12)
	floor_body.add_child(floor_shape)

func _create_minerals(pos: Vector3, origin: Vector3) -> void:
	var mineral_types: Array = BIOME_MINERALS.get(preview_depth, ["copper"])
	var mineral_count: int = _rng.randi_range(3, 6)
	
	for i in range(mineral_count):
		var mineral_type: String = mineral_types[_rng.randi() % mineral_types.size()]
		var mineral_pos: Vector3 = pos + origin + Vector3(
			_rng.randf_range(-4.0, 4.0),
			-1.5,
			_rng.randf_range(-4.0, 4.0)
		)
		
		var mineral: MeshInstance3D = MeshInstance3D.new()
		mineral.name = "Mineral_%s_%d" % [mineral_type, i]
		mineral.position = mineral_pos
		
		var crystal_mesh: BoxMesh = BoxMesh.new()
		crystal_mesh.size = Vector3(0.5, 0.8, 0.5)
		mineral.mesh = crystal_mesh
		
		var mineral_mat: StandardMaterial3D = StandardMaterial3D.new()
		mineral_mat.albedo_color = MINERAL_COLORS.get(mineral_type, Color.WHITE)
		mineral_mat.emission_enabled = true
		mineral_mat.emission = MINERAL_COLORS.get(mineral_type, Color.WHITE)
		mineral_mat.emission_energy_multiplier = 0.3
		mineral.material_override = mineral_mat
		
		add_child(mineral)
		mineral.owner = owner if owner else self
		_generated_children.append(mineral)

func _create_tunnel(from_pos: Vector3, to_pos: Vector3, origin: Vector3) -> void:
	var direction: Vector3 = (to_pos - from_pos).normalized()
	var distance: float = from_pos.distance_to(to_pos)
	var midpoint: Vector3 = (from_pos + to_pos) / 2.0 + origin
	
	var tunnel: Node3D = Node3D.new()
	tunnel.name = "Tunnel"
	tunnel.position = midpoint
	add_child(tunnel)
	tunnel.owner = owner if owner else self
	_generated_children.append(tunnel)
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var tunnel_radius: float = 2.0
	var segments: int = 8
	var ring_count: int = 5
	var segment_length: float = distance / float(ring_count)
	
	var up: Vector3 = Vector3.UP
	if absf(direction.dot(up)) > 0.99:
		up = Vector3.FORWARD
	var right: Vector3 = direction.cross(up).normalized()
	if right.length() < 0.001:
		right = Vector3.RIGHT
	var real_up: Vector3 = right.cross(direction).normalized()
	
	for i in range(ring_count + 1):
		var center: Vector3 = Vector3(0, 0, (i - ring_count / 2.0) * segment_length)
		
		for j in range(segments):
			var angle_a: float = float(j) / float(segments) * TAU
			var angle_b: float = float(j + 1) / float(segments) * TAU
			
			var wobble_a: float = 0.8 + 0.2 * sin(float(i) * 1.7 + float(j) * 2.3)
			var wobble_b: float = 0.8 + 0.2 * sin(float(i) * 1.7 + float(j + 1) * 2.3)
			
			var p1: Vector3 = center + (right * cos(angle_a) + real_up * sin(angle_a)) * tunnel_radius * wobble_a
			var p2: Vector3 = center + (right * cos(angle_b) + real_up * sin(angle_b)) * tunnel_radius * wobble_b
			
			var next_center: Vector3 = Vector3(0, 0, (i + 1 - ring_count / 2.0) * segment_length)
			var p3: Vector3 = next_center + (right * cos(angle_a) + real_up * sin(angle_a)) * tunnel_radius * wobble_a
			var p4: Vector3 = next_center + (right * cos(angle_b) + real_up * sin(angle_b)) * tunnel_radius * wobble_b
			
			st.add_vertex(p1)
			st.add_vertex(p2)
			st.add_vertex(p3)
			st.add_vertex(p2)
			st.add_vertex(p4)
			st.add_vertex(p3)
	
	var tunnel_mesh: ArrayMesh = st.commit()
	var mesh_inst: MeshInstance3D = MeshInstance3D.new()
	mesh_inst.mesh = tunnel_mesh
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.22, 0.2, 0.18)
	mat.roughness = 0.9
	mesh_inst.material_override = mat
	tunnel.add_child(mesh_inst)
	mesh_inst.owner = tunnel.owner
	
	var static_body: StaticBody3D = StaticBody3D.new()
	static_body.name = "TunnelBody"
	static_body.collision_layer = 1
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	collision_shape.shape = tunnel_mesh.create_trimesh_shape()
	static_body.add_child(collision_shape)
	tunnel.add_child(static_body)
	static_body.owner = tunnel.owner
