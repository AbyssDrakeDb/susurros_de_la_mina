extends Node
class_name RoomSpawnerClass

## ─── Métodos Públicos ────────────────────────────────
func spawn_room(template: RoomTemplate, spawn_position: Vector3, parent: Node3D) -> Node3D:
	if template == null or template.scene == null:
		push_error("RoomSpawner: Template o escena nula")
		return null
	
	var room: Node3D = template.scene.instantiate() as Node3D
	if room == null:
		push_error("RoomSpawner: Error instanciando sala")
		return null
	
	room.position = spawn_position
	parent.add_child(room)
	room.owner = parent.owner
	
	return room

func connect_rooms(room_a: Node3D, room_b: Node3D, tunnel_scene: PackedScene = null) -> Node3D:
	if room_a == null or room_b == null:
		return null
	
	if room_a.get_parent() == null:
		return null
	
	var pos_a: Vector3 = room_a.position
	var pos_b: Vector3 = room_b.position
	var midpoint: Vector3 = (pos_a + pos_b) / 2.0
	
	var parent: Node3D = room_a.get_parent()
	
	if tunnel_scene != null:
		var tunnel: Node3D = tunnel_scene.instantiate() as Node3D
		if tunnel != null:
			tunnel.position = midpoint
			parent.add_child(tunnel)
			tunnel.owner = parent.owner
			var direction: Vector3 = (pos_b - pos_a).normalized()
			if direction.length() > 0.001:
				tunnel.look_at(tunnel.position + direction, Vector3.UP)
			return tunnel
	
	return _create_default_tunnel(midpoint, pos_a, pos_b, parent)

## ─── Métodos Privados ────────────────────────────────
func _create_default_tunnel(midpoint: Vector3, from_pos: Vector3, to_pos: Vector3, parent: Node3D) -> Node3D:
	var direction: Vector3 = (to_pos - from_pos).normalized()
	var distance: float = from_pos.distance_to(to_pos)
	var tunnel_length: float = maxf(distance, 5.0)
	
	var tunnel: Node3D = Node3D.new()
	tunnel.position = midpoint
	
	var static_body: StaticBody3D = StaticBody3D.new()
	static_body.name = "TunnelBody"
	static_body.collision_layer = 1
	
	var tunnel_radius: float = 2.0
	var segments: int = 8
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var up: Vector3 = Vector3.UP
	if absf(direction.dot(up)) > 0.99:
		up = Vector3.FORWARD
	
	var right: Vector3 = direction.cross(up).normalized()
	if right.length() < 0.001:
		right = Vector3.RIGHT
	var real_up: Vector3 = right.cross(direction).normalized()
	
	var ring_count: int = 6
	var segment_length: float = tunnel_length / float(ring_count)
	
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
	mesh_inst.material_override = mat
	tunnel.add_child(mesh_inst)
	
	var trimesh_shape: Shape3D = tunnel_mesh.create_trimesh_shape()
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	collision_shape.shape = trimesh_shape
	static_body.add_child(collision_shape)
	tunnel.add_child(static_body)
	
	parent.add_child(tunnel)
	tunnel.owner = parent.owner
	
	return tunnel
