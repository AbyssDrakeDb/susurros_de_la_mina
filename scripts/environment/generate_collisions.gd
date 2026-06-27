extends Node

## GenerateCollisions - Genera colisiones trimesh para meshes importados
##
## Itera sobre todos los MeshInstance3D hijos y crea StaticBody3D
## con colisión trimesh para cada uno.

func _ready() -> void:
	await get_tree().process_frame
	_generate_collisions()

func _generate_collisions() -> void:
	var parent: Node3D = get_parent()
	if parent == null:
		return
	
	_collect_meshes(parent)
	print("[GenerateCollisions] Colisiones generadas para cueva")

func _collect_meshes(node: Node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D and child != self:
			_create_collision_for_mesh(child)
		elif child.get_child_count() > 0:
			_collect_meshes(child)

func _create_collision_for_mesh(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance.mesh == null:
		return
	
	var static_body: StaticBody3D = StaticBody3D.new()
	static_body.name = mesh_instance.name + "_Collision"
	static_body.collision_layer = 1
	
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	
	var shape: Shape3D = mesh_instance.mesh.create_trimesh_shape()
	collision_shape.shape = shape
	
	static_body.add_child(collision_shape)
	mesh_instance.get_parent().add_child(static_body)
	static_body.global_transform = mesh_instance.global_transform
