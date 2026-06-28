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
	
	return _create_default_tunnel(midpoint, pos_b, parent)

## ─── Métodos Privados ────────────────────────────────
func _create_default_tunnel(midpoint: Vector3, look_target: Vector3, parent: Node3D) -> Node3D:
	var tunnel: StaticBody3D = StaticBody3D.new()
	tunnel.position = midpoint
	
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(3, 3, 5)
	shape.shape = box
	tunnel.add_child(shape)
	
	var mesh_inst: MeshInstance3D = MeshInstance3D.new()
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.size = Vector3(3, 3, 5)
	mesh_inst.mesh = box_mesh
	
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.22, 0.2)
	mesh_inst.material_override = mat
	tunnel.add_child(mesh_inst)
	
	parent.add_child(tunnel)
	tunnel.owner = parent.owner
	
	var direction: Vector3 = (look_target - midpoint).normalized()
	if direction.length() > 0.001:
		tunnel.look_at(tunnel.position + direction, Vector3.UP)
	
	return tunnel
