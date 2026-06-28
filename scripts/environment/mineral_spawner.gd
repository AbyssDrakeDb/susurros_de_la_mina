extends Node
class_name MineralSpawnerClass

## ─── Escena de mineral ────────────────────────────────
const MINERAL_SCENE: PackedScene = preload("res://scenes/minerals/mineral_node.tscn")

## ─── Métodos Públicos ────────────────────────────────
func spawn_minerals_in_room(room: Node3D, biome: BiomeResource) -> Array[Node3D]:
	var spawned: Array[Node3D] = []
	
	if biome == null or biome.mineral_table.is_empty():
		return spawned
	
	var spawn_points: Node3D = room.get_node_or_null("SpawnPoints")
	if spawn_points == null:
		return spawned
	
	for point in spawn_points.get_children():
		if not point is Marker3D:
			continue
		
		var entry: MineralSpawnEntry = _pick_mineral_entry(biome)
		if entry == null or entry.mineral == null:
			continue
		
		var count: int = randi_range(entry.min_count, entry.max_count)
		for j in range(count):
			var mineral: MineralNode = _create_mineral(entry.mineral, point.global_position)
			if mineral != null:
				mineral.position += Vector3(
					randf_range(-0.5, 0.5),
					0.0,
					randf_range(-0.5, 0.5)
				)
				room.add_child(mineral)
				mineral.owner = room.owner
				spawned.append(mineral)
	
	return spawned

func spawn_mineral_at(position: Vector3, mineral_data: MineralResource, parent: Node3D) -> MineralNode:
	var mineral: MineralNode = _create_mineral(mineral_data, position)
	if mineral != null:
		parent.add_child(mineral)
		mineral.owner = parent.owner
	return mineral

## ─── Métodos Privados ────────────────────────────────
func _pick_mineral_entry(biome: BiomeResource) -> MineralSpawnEntry:
	var total_weight: float = 0.0
	for entry in biome.mineral_table:
		if entry != null and entry.mineral != null:
			total_weight += entry.weight
	
	if total_weight <= 0.0:
		return null
	
	var roll: float = randf() * total_weight
	var cumulative: float = 0.0
	for entry in biome.mineral_table:
		if entry == null or entry.mineral == null:
			continue
		cumulative += entry.weight
		if roll <= cumulative:
			return entry
	
	return biome.mineral_table.back()

func _create_mineral(mineral_data: MineralResource, spawn_pos: Vector3) -> MineralNode:
	var mineral: MineralNode = MINERAL_SCENE.instantiate() as MineralNode
	if mineral == null:
		return null
	
	mineral.mineral_data = mineral_data
	mineral.position = spawn_pos
	return mineral
