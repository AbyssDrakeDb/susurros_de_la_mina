@tool
extends Node3D

## CavePreview - Mapa completo con escala reducida y labels de profundidad
##
## Instancea cave_example.tscn a escala reducida para ver todo el mapa.
## Muestra zonas de profundidad, biomas, y minerales.

@export var preview_depth: int = 1 : set = _set_preview_depth
@export var auto_generate: bool = false : set = _set_auto_generate
@export_range(0.03, 0.2, 0.01) var cave_scale: float = 0.06 : set = _set_cave_scale

var _generated: Array[Node] = []
var _example_scene: PackedScene = null

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

const DEPTH_ZONES := [
	{"z_start": -2500.0, "z_end": -4500.0, "level": 0},
	{"z_start": -4500.0, "z_end": -6500.0, "level": 1},
	{"z_start": -6500.0, "z_end": -8500.0, "level": 2},
	{"z_start": -8500.0, "z_end": -10000.0, "level": 3},
	{"z_start": -10000.0, "z_end": -11500.0, "level": 4},
	{"z_start": -11500.0, "z_end": -13000.0, "level": 5},
	{"z_start": -13000.0, "z_end": -15500.0, "level": 6},
	{"z_start": -15500.0, "z_end": -18000.0, "level": 7},
	{"z_start": -18000.0, "z_end": -20500.0, "level": 8},
	{"z_start": -20500.0, "z_end": -23000.0, "level": 9},
	{"z_start": -23000.0, "z_end": -26000.0, "level": 10},
]

func _set_preview_depth(v: int) -> void:
	preview_depth = clampi(v, 0, 10)
	if auto_generate and Engine.is_editor_hint():
		generate()

func _set_auto_generate(v: bool) -> void:
	auto_generate = v
	if auto_generate and Engine.is_editor_hint():
		generate()

func _set_cave_scale(v: float) -> void:
	cave_scale = v

func generate() -> void:
	if not Engine.is_editor_hint():
		return
	_clear()
	
	_example_scene = load(CAVE_EXAMPLE) as PackedScene
	if _example_scene == null:
		_label(Vector3(0, 10, 0), "ERROR: No se pudo cargar cave_example.tscn", Color.RED, 32)
		return
	
	var instance: Node = _example_scene.instantiate()
	if instance == null:
		return
	add_child(instance)
	if owner:
		instance.owner = owner
	instance.scale = Vector3(cave_scale, cave_scale, cave_scale)
	_generated.append(instance)
	
	var s: float = cave_scale
	
	_label(
		Vector3(0, 50 * s, -14000 * s),
		"MAPA CUEVA | Escala: %.2f | 78 piezas | Z: -2490 a -25130" % cave_scale,
		Color.WHITE, 32
	)
	
	_draw_depth_zones(s)
	_draw_minerals_legend(s)
	_draw_axes(s)

func clear_editor() -> void:
	_clear()

func _clear() -> void:
	for n in _generated:
		if n and is_instance_valid(n):
			n.queue_free()
	_generated.clear()

func _draw_depth_zones(s: float) -> void:
	for zone in DEPTH_ZONES:
		var z_center: float = (zone["z_start"] + zone["z_end"]) * 0.5
		var z_span: float = zone["z_end"] - zone["z_start"]
		var level: int = zone["level"]
		var biome_name: String = BIOME_NAMES.get(level, "?")
		var biome_color: Color = BIOME_COLORS.get(level, Color.WHITE)
		var minerals: Array = BIOME_MINERALS.get(level, [])
		var mineral_str: String = ", ".join(minerals) if not minerals.is_empty() else "-"
		
		var lbl_text: String = "Nivel %d: %s\n%s" % [level, biome_name, mineral_str]
		var lbl: Label3D = Label3D.new()
		lbl.position = Vector3(140 * s, 0, z_center * s)
		lbl.text = lbl_text
		lbl.font_size = 18
		lbl.modulate = biome_color
		lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		lbl.no_depth_test = true
		lbl.pixel_size = 2.0
		add_child(lbl)
		if owner:
			lbl.owner = owner
		_generated.append(lbl)
		
		var line_y: float = -5 * s
		_draw_line(
			Vector3(-60 * s, line_y, zone["z_start"] * s),
			Vector3(130 * s, line_y, zone["z_start"] * s),
			biome_color * Color(1, 1, 1, 0.4)
		)

func _draw_minerals_legend(s: float) -> void:
	var legend_x: float = -120 * s
	var legend_z: float = -3000 * s
	var y: float = 0
	
	_label(Vector3(legend_x, 40 * s + y, legend_z), "LEYENDA MINERALES", Color.WHITE, 16)
	y -= 8 * s
	
	for mtype in MINERAL_TINT:
		var color: Color = MINERAL_TINT[mtype]
		_label(Vector3(legend_x, 30 * s + y, legend_z), "  %s" % mtype, color, 14)
		y -= 6 * s

func _draw_axes(s: float) -> void:
	_label(Vector3(160 * s, 10 * s, -2500 * s), "N (Entrada)", Color.RED, 20)
	_label(Vector3(160 * s, 10 * s, -25000 * s), "S (Profundo)", Color.WHITE, 20)
	_label(Vector3(-80 * s, 10 * s, -14000 * s), "W", Color.WHITE, 16)
	_label(Vector3(160 * s, 10 * s, -14000 * s), "E", Color.WHITE, 16)

func _draw_line(from: Vector3, to: Vector3, color: Color) -> void:
	var mid: Vector3 = (from + to) * 0.5
	var dist: float = from.distance_to(to)
	if dist < 0.01:
		return
	
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(0.3, 0.3, dist)
	
	var inst: MeshInstance3D = MeshInstance3D.new()
	inst.mesh = mesh
	inst.position = mid
	inst.look_at(to, Vector3.UP)
	add_child(inst)
	if owner:
		inst.owner = owner
	_generated.append(inst)
	
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.material = mat

func _label(pos: Vector3, text: String, color: Color, size: int = 24) -> void:
	var l: Label3D = Label3D.new()
	l.position = pos
	l.text = text
	l.font_size = size
	l.modulate = color
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.no_depth_test = true
	l.pixel_size = 1.5
	add_child(l)
	if owner:
		l.owner = owner
	_generated.append(l)
