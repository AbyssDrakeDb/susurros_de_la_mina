extends Node
class_name HazardSpawnerClass

## ─── Tipos de hazard ──────────────────────────────────
enum HazardType { SPIKE_TRAP, FALLING_ROCKS, GAS_LEAK }

## ─── Configuración por tipo ──────────────────────────
const HAZARD_CONFIGS: Dictionary = {
	HazardType.SPIKE_TRAP: {
		"damage": 15,
		"interval": 1.0,
		"size": Vector3(2, 1, 2),
		"color": Color(0.6, 0.2, 0.1),
	},
	HazardType.FALLING_ROCKS: {
		"damage": 25,
		"interval": 2.0,
		"size": Vector3(1.5, 1.5, 1.5),
		"color": Color(0.4, 0.35, 0.3),
	},
	HazardType.GAS_LEAK: {
		"damage": 8,
		"interval": 0.5,
		"size": Vector3(3, 2, 3),
		"color": Color(0.3, 0.6, 0.2),
	},
}

## ─── Métodos Públicos ────────────────────────────────
func spawn_hazards_in_room(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
	var spawned: Array[Node3D] = []
	
	if biome == null or randf() > biome.hazard_chance:
		return spawned
	
	var spawn_points: Node3D = room.get_node_or_null("HazardPoints")
	if spawn_points == null:
		spawn_points = room.get_node_or_null("SpawnPoints")
	if spawn_points == null:
		return spawned
	
	var hazard_count: int = randi_range(1, 3)
	var points: Array[Node3D] = []
	for child in spawn_points.get_children():
		if child is Marker3D:
			points.append(child)
	points.shuffle()
	
	for i in range(mini(hazard_count, points.size())):
		var hazard_type: HazardType = _pick_hazard_type(biome)
		var hazard: Node3D = _create_hazard(hazard_type, points[i].global_position)
		if hazard != null:
			room.add_child(hazard)
			hazard.owner = room.owner
			spawned.append(hazard)
	
	return spawned

## ─── Métodos Privados ────────────────────────────────
func _pick_hazard_type(biome: BiomeResource) -> HazardType:
	var types: Array[HazardType] = [HazardType.SPIKE_TRAP]
	
	if biome != null and biome.depth_min >= 4:
		types.append(HazardType.FALLING_ROCKS)
	if biome != null and biome.depth_min >= 6:
		types.append(HazardType.GAS_LEAK)
	
	return types[randi() % types.size()]

func _create_hazard(hazard_type: HazardType, spawn_pos: Vector3) -> Node3D:
	var config: Dictionary = HAZARD_CONFIGS[hazard_type]
	
	var area: Area3D = Area3D.new()
	area.collision_layer = 0
	area.collision_mask = 2
	area.position = spawn_pos
	
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = config["size"]
	shape.shape = box
	area.add_child(shape)
	
	var mesh_inst: MeshInstance3D = MeshInstance3D.new()
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.size = config["size"]
	mesh_inst.mesh = box_mesh
	mesh_inst.position.y = -config["size"].y * 0.25
	
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = config["color"]
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color.a = 0.6
	mesh_inst.material_override = mat
	area.add_child(mesh_inst)
	
	var label: Label3D = Label3D.new()
	label.position.y = config["size"].y + 0.5
	label.visible = false
	label.pixel_size = 0.004
	label.modulate = Color(1, 0.3, 0.3, 1)
	label.text = _get_hazard_label(hazard_type)
	label.font_size = 20
	area.add_child(label)
	
	area.set_script(load("res://scripts/environment/hazard.gd"))
	area.set("damage_amount", config["damage"])
	area.set("damage_interval", config["interval"])
	
	return area

func _get_hazard_label(hazard_type: HazardType) -> String:
	match hazard_type:
		HazardType.SPIKE_TRAP: return "¡Pinchos!"
		HazardType.FALLING_ROCKS: return "¡Rocas!"
		HazardType.GAS_LEAK: return "¡Gas!"
		_: return "¡Peligro!"
