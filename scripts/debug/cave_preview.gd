@tool
extends Node3D

## CavePreview - Previsualización de cueva en editor
##
## Agrega este script a un Node3D en el editor.
## Cambia preview_depth en el Inspector para generar.
## Muestra sala, tuneles, minerales, suelo y labels de debug.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate

var _generated_children: Array[Node3D] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

const BIOME_DATA: Dictionary = {
	0: Color(0.9, 0.9, 0.8),
	1: Color(0.8, 0.6, 0.3),
	2: Color(0.8, 0.6, 0.3),
	3: Color(0.8, 0.6, 0.3),
	4: Color(0.3, 0.7, 1.0),
	5: Color(0.3, 0.7, 1.0),
	6: Color(0.7, 0.5, 0.3),
	7: Color(0.7, 0.5, 0.3),
	8: Color(0.3, 0.3, 0.5),
	9: Color(0.3, 0.3, 0.5),
	10: Color(0.8, 0.2, 1.0),
}

const MINERAL_COLORS: Dictionary = {
	"copper": Color(1.0, 0.5, 0.2),
	"iron": Color(0.7, 0.7, 0.8),
	"silver": Color(0.9, 0.9, 1.0),
	"gold": Color(1.0, 0.9, 0.1),
	"crystal": Color(0.2, 0.9, 1.0),
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

const BIOME_NAMES: Dictionary = {
	0: "Superficie", 1: "Somero", 2: "Somero", 3: "Somero",
	4: "Cristalino", 5: "Cristalino", 6: "Abandonado", 7: "Abandonado",
	8: "Profundo", 9: "Profundo", 10: "Maldito",
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
	
	var biome_name: String = BIOME_NAMES.get(preview_depth, "Desconocido")
	_add_label(Vector3(0, 8, 0), "BIOMA: %s (Depth %d)" % [biome_name, preview_depth], Color.WHITE, 48)
	
	var room_count: int = _rng.randi_range(2, 4)
	var room_spacing: float = 30.0
	
	for i in range(room_count):
		var offset: float = (i - room_count / 2.0) * room_spacing
		var room_pos: Vector3 = Vector3(offset, 0.0, -i * room_spacing)
		
		_create_room_debug(room_pos, i)
		_create_floor_debug(room_pos, i)
		_create_minerals_debug(room_pos, i)
		_add_label(room_pos + Vector3(0, 6, 0), "SALA %d" % i, Color.YELLOW, 32)
		_add_label(room_pos + Vector3(0, 5, 0), "Pos: %s" % str(room_pos), Color.GRAY, 20)
		
		if i > 0:
			var prev_pos: Vector3 = Vector3((i - 1 - room_count / 2.0) * room_spacing, 0.0, -(i - 1) * room_spacing)
			_create_tunnel_debug(prev_pos, room_pos, i)
	
	_add_compass(Vector3(0, 10, 0))

func _clear_preview() -> void:
	for child in _generated_children:
		if child != null and is_instance_valid(child):
			child.queue_free()
	_generated_children.clear()

func _add_label(pos: Vector3, text: String, color: Color, font_size: int = 24) -> void:
	var label: Label3D = Label3D.new()
	label.position = pos
	label.text = text
	label.font_size = font_size
	label.modulate = color
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	add_child(label)
	label.owner = owner if owner else self
	_generated_children.append(label)

func _create_room_debug(pos: Vector3, index: int) -> void:
	var room: Node3D = Node3D.new()
	room.name = "Room_%d" % index
	room.position = pos
	add_child(room)
	room.owner = owner if owner else self
	_generated_children.append(room)
	
	var room_radius: float = 8.0
	var room_height: float = 7.0
	var segments: int = 10
	var rings: int = 5
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(rings + 1):
		var y: float = float(i) / float(rings) * room_height - room_height / 2.0
		var radius_at_y: float = room_radius * (1.0 - 0.25 * pow(float(i) / float(rings) - 0.5, 2.0))
		
		for j in range(segments):
			var angle_a: float = float(j) / float(segments) * TAU
			var angle_b: float = float(j + 1) / float(segments) * TAU
			
			var wobble_a: float = 0.85 + 0.15 * sin(float(i) * 2.1 + float(j) * 1.7)
			var wobble_b: float = 0.85 + 0.15 * sin(float(i) * 2.1 + float(j + 1) * 1.7)
			
			var p1: Vector3 = Vector3(cos(angle_a) * radius_at_y * wobble_a, y, sin(angle_a) * radius_at_y * wobble_a)
			var p2: Vector3 = Vector3(cos(angle_b) * radius_at_y * wobble_b, y, sin(angle_b) * radius_at_y * wobble_b)
			
			var next_y: float = float(i + 1) / float(rings) * room_height - room_height / 2.0
			var next_radius: float = room_radius * (1.0 - 0.25 * pow(float(i + 1) / float(rings) - 0.5, 2.0))
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
	mat.albedo_color = BIOME_DATA.get(preview_depth, Color.GRAY)
	mat.roughness = 0.8
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
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

func _create_floor_debug(pos: Vector3, index: int) -> void:
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "Floor_%d" % index
	floor_body.position = pos + Vector3(0, -3.5, 0)
	floor_body.collision_layer = 1
	add_child(floor_body)
	floor_body.owner = owner if owner else self
	_generated_children.append(floor_body)
	
	var floor_mesh_inst: MeshInstance3D = MeshInstance3D.new()
	var floor_box: BoxMesh = BoxMesh.new()
	floor_box.size = Vector3(16, 0.3, 16)
	floor_mesh_inst.mesh = floor_box
	var floor_mat: StandardMaterial3D = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.3, 0.25, 0.2)
	floor_mesh_inst.material_override = floor_mat
	floor_body.add_child(floor_mesh_inst)
	floor_mesh_inst.owner = floor_body.owner
	
	var floor_shape: CollisionShape3D = CollisionShape3D.new()
	floor_shape.shape = BoxShape3D.new()
	floor_shape.shape.size = Vector3(16, 0.3, 16)
	floor_body.add_child(floor_shape)

func _create_minerals_debug(pos: Vector3, room_index: int) -> void:
	var mineral_types: Array = BIOME_MINERALS.get(preview_depth, ["copper"])
	var mineral_count: int = _rng.randi_range(4, 8)
	
	for i in range(mineral_count):
		var mineral_type: String = mineral_types[_rng.randi() % mineral_types.size()]
		var mineral_pos: Vector3 = pos + Vector3(
			_rng.randf_range(-5.0, 5.0),
			-2.5,
			_rng.randf_range(-5.0, 5.0)
		)
		
		var mineral: MeshInstance3D = MeshInstance3D.new()
		mineral.name = "Mineral_%s_%d" % [mineral_type, i]
		mineral.position = mineral_pos
		
		var crystal_mesh: PrismMesh = PrismMesh.new()
		crystal_mesh.size = Vector3(0.8, 1.5, 0.8)
		mineral.mesh = crystal_mesh
		
		var mineral_mat: StandardMaterial3D = StandardMaterial3D.new()
		mineral_mat.albedo_color = MINERAL_COLORS.get(mineral_type, Color.WHITE)
		mineral_mat.emission_enabled = true
		mineral_mat.emission = MINERAL_COLORS.get(mineral_type, Color.WHITE)
		mineral_mat.emission_energy_multiplier = 1.0
		mineral_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		mineral.material_override = mineral_mat
		
		add_child(mineral)
		mineral.owner = owner if owner else self
		_generated_children.append(mineral)

func _create_tunnel_debug(from_pos: Vector3, to_pos: Vector3, index: int) -> void:
	var direction: Vector3 = (to_pos - from_pos).normalized()
	var distance: float = from_pos.distance_to(to_pos)
	var midpoint: Vector3 = (from_pos + to_pos) / 2.0
	
	var tunnel: Node3D = Node3D.new()
	tunnel.name = "Tunnel_%d" % index
	tunnel.position = midpoint
	add_child(tunnel)
	tunnel.owner = owner if owner else self
	_generated_children.append(tunnel)
	
	var tunnel_radius: float = 3.0
	var segments: int = 8
	var ring_count: int = 6
	var segment_length: float = distance / float(ring_count)
	
	var up: Vector3 = Vector3.UP
	if absf(direction.dot(up)) > 0.99:
		up = Vector3.FORWARD
	var right: Vector3 = direction.cross(up).normalized()
	if right.length() < 0.001:
		right = Vector3.RIGHT
	var real_up: Vector3 = right.cross(direction).normalized()
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
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
	mat.albedo_color = Color(0.4, 0.35, 0.3)
	mat.roughness = 0.8
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
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

func _add_compass(pos: Vector3) -> void:
	_add_label(pos + Vector3(0, 0, -3), "N", Color.RED, 32)
	_add_label(pos + Vector3(0, 0, 3), "S", Color.WHITE, 32)
	_add_label(pos + Vector3(3, 0, 0), "E", Color.WHITE, 32)
	_add_label(pos + Vector3(-3, 0, 0), "O", Color.WHITE, 32)
	_add_label(pos, "ORIGEN", Color.GREEN, 28)
