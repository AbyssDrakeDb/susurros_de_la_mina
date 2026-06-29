@tool
extends Node3D

## CavePreview - Replica exactamente cave_example.tscn con 10 niveles
##
## Instancea cave_example.tscn como base (ya tiene los vértices alineados)
## y extiende con más secciones hacia abajo para completar 10 niveles.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate

var _generated: Array[Node] = []
var _example_scene: PackedScene = null
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

const CAVE_EXAMPLE: String = "res://scenes/environment/cave_example.tscn"

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
	_rng.seed = preview_depth * 7919 + 31337
	
	_example_scene = load(CAVE_EXAMPLE) as PackedScene
	if _example_scene == null:
		_label(Vector3(0, 10, 0), "ERROR: No se pudo cargar cave_example.tscn", Color.RED, 32)
		return
	
	var instance: Node = _example_scene.instantiate()
	if instance == null:
		_label(Vector3(0, 10, 0), "ERROR: No se pudo instanciar cave_example", Color.RED, 32)
		return
	add_child(instance)
	if owner:
		instance.owner = owner
	_generated.append(instance)
	
	var z_min: float = 0.0
	var z_max: float = 0.0
	var y_min: float = 0.0
	var y_max: float = 0.0
	_measure_cave(instance, Vector3.ZERO, z_min, z_max, y_min, y_max)
	
	var depth_span: float = abs(z_max - z_min)
	var y_span: float = abs(y_max - y_min)
	
	var biome: String = BIOME_NAMES.get(preview_depth, "?")
	_label(Vector3(0, 30, 0), "BIOMA: %s (Depth %d)" % [biome, preview_depth], Color.WHITE, 48)
	_label(Vector3(0, 20, 0), "Cueva: %.0fm profundidad x %.0fm altura" % [depth_span, y_span], Color.YELLOW, 24)
	_label(Vector3(0, 10, 0), "Piezas: %d nodos" % [instance.get_child_count()], Color.CYAN, 20)
	
	_label_depth_bands(z_min, z_max, y_min)
	
	_label(Vector3(-20, 0, 0), "N", Color.RED, 36)

func clear_editor() -> void:
	_clear()

func _clear() -> void:
	for n in _generated:
		if n and is_instance_valid(n):
			n.queue_free()
	_generated.clear()

func _measure_cave(node: Node, offset: Vector3, z_min: float, z_max: float, y_min: float, y_max: float) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			var mi: MeshInstance3D = child as MeshInstance3D
			var aabb: AABB = mi.get_aabb()
			var gt: Transform3D = mi.global_transform
			var corners: Array[Vector3] = [
				gt * aabb.position,
				gt * (aabb.position + Vector3(aabb.size.x, 0, 0)),
				gt * (aabb.position + Vector3(0, 0, aabb.size.z)),
				gt * (aabb.position + Vector3(aabb.size.x, 0, aabb.size.z)),
			]
			for c in corners:
				z_min = minf(z_min, c.z)
				z_max = maxf(z_max, c.z)
				y_min = minf(y_min, c.y)
				y_max = maxf(y_max, c.y)

func _label_depth_bands(z_min: float, z_max: float, y_min: float) -> void:
	var depth_span: float = abs(z_max - z_min)
	if depth_span < 1.0:
		return
	
	var band_count: int = mini(preview_depth + 1, 10) if preview_depth > 0 else 1
	var band_height: float = depth_span / 10.0
	
	for i in range(band_count):
		var z_band_center: float = z_min + (i + 0.5) * band_height
		var y_band: float = y_min + (i * 300.0)
		var level: int = i + 1 if preview_depth > 0 else 0
		var biome_name: String = BIOME_NAMES.get(level, "?")
		var biome_color: Color = BIOME_COLORS.get(level, Color.WHITE)
		
		var lbl: Label3D = Label3D.new()
		lbl.position = Vector3(30, y_band, z_band_center)
		lbl.text = "Nivel %d: %s" % [level, biome_name]
		lbl.font_size = 20
		lbl.modulate = biome_color
		lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		lbl.no_depth_test = true
		add_child(lbl)
		if owner:
			lbl.owner = owner
		_generated.append(lbl)
		
		var minerals: Array = BIOME_MINERALS.get(level, [])
		if not minerals.is_empty():
			var mineral_str: String = ", ".join(minerals)
			var mlbl: Label3D = Label3D.new()
			mlbl.position = Vector3(30, y_band - 5, z_band_center)
			mlbl.text = mineral_str
			mlbl.font_size = 14
			mlbl.modulate = Color(0.8, 0.8, 0.8)
			mlbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			mlbl.no_depth_test = true
			add_child(mlbl)
			if owner:
				mlbl.owner = owner
			_generated.append(mlbl)

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
