extends StaticBody3D
class_name MineralNode

## ─── Señales ──────────────────────────────────────────
signal mined(node: MineralNode, amount: int)
signal destroyed(node: MineralNode)
signal health_changed(new_health: int)

## ─── Exported Properties ─────────────────────────────
@export var mineral_type: String = "copper"
@export var max_health: int = 100
@export var yield_amount: Vector2i = Vector2i(1, 3)
@export var rarity: float = 1.0

## ─── State ────────────────────────────────────────────
var current_health: int
var is_depleted: bool = false

## ─── Materiales únicos por instancia ──────────────────
var _body_material: StandardMaterial3D
var _healthbar_bg_material: StandardMaterial3D
var _healthbar_fill_material: StandardMaterial3D

## ─── Visual Feedback ─────────────────────────────────
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var health_bar_3d: Node3D = $HealthBar3D
@onready var health_fill: MeshInstance3D = $HealthBar3D/HealthFill
@onready var health_label: Label3D = $HealthBar3D/HealthLabel

## ─── Colores por tipo ────────────────────────────────
const MINERAL_COLORS: Dictionary = {
	"copper": Color(0.8, 0.4, 0.2),
	"iron": Color(0.5, 0.5, 0.55),
	"silver": Color(0.8, 0.8, 0.9),
	"gold": Color(1.0, 0.84, 0.0),
	"crystal": Color(0.4, 0.8, 1.0),
}

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	current_health = max_health
	_create_unique_materials()
	_apply_colors()

## ─── Private Methods ──────────────────────────────────
func _create_unique_materials() -> void:
	# Material único para el cuerpo del mineral
	_body_material = StandardMaterial3D.new()
	_body_material.albedo_color = MINERAL_COLORS.get(mineral_type, Color.WHITE)
	mesh.material_override = _body_material
	
	# Material único para el fondo de la barra de vida
	_healthbar_bg_material = StandardMaterial3D.new()
	_healthbar_bg_material.albedo_color = Color(0.15, 0.15, 0.15)
	if health_bar_3d:
		var bg: MeshInstance3D = health_bar_3d.get_node_or_null("HealthBarBG")
		if bg:
			bg.material_override = _healthbar_bg_material
	
	# Material único para el fill de la barra de vida
	_healthbar_fill_material = StandardMaterial3D.new()
	_healthbar_fill_material.albedo_color = Color(0.2, 0.8, 0.2)
	if health_fill:
		health_fill.material_override = _healthbar_fill_material

func _apply_colors() -> void:
	_update_health_bar()

## ─── Public Methods ───────────────────────────────────
func take_damage(amount: int, tool_type: String = "pickaxe") -> void:
	if is_depleted:
		return
	
	var damage_modifier: float = _get_tool_modifier(tool_type)
	var final_damage: int = int(amount * damage_modifier)
	
	current_health = maxi(current_health - final_damage, 0)
	health_changed.emit(current_health)
	
	_play_hit_animation()
	_update_health_bar()
	
	var actual_yield: int = randi_range(yield_amount.x, yield_amount.y)
	mined.emit(self, actual_yield)
	
	if current_health <= 0:
		_destroy()

func get_info() -> Dictionary:
	return {
		"type": mineral_type,
		"health": current_health,
		"max_health": max_health,
		"rarity": rarity,
		"depleted": is_depleted
	}

func _update_health_bar() -> void:
	if health_bar_3d == null or _healthbar_fill_material == null:
		return
	
	var health_percent: float = float(current_health) / float(max_health)
	
	# Escalar barra de fill
	if health_fill:
		health_fill.scale.x = maxf(health_percent, 0.001)
	
	# Cambiar color del fill (material ya es único por instancia)
	if health_percent > 0.6:
		_healthbar_fill_material.albedo_color = Color(0.2, 0.8, 0.2)
	elif health_percent > 0.3:
		_healthbar_fill_material.albedo_color = Color(0.8, 0.8, 0.2)
	else:
		_healthbar_fill_material.albedo_color = Color(0.8, 0.2, 0.2)
	
	# Actualizar label
	if health_label:
		health_label.text = "%d / %d" % [current_health, max_health]

func _get_tool_modifier(tool_type: String) -> float:
	match tool_type:
		"pickaxe_basic": return 1.0
		"pickaxe_reinforced": return 1.5
		"drill": return 2.0
		_: return 1.0

func _play_hit_animation() -> void:
	if _body_material:
		var original_color: Color = MINERAL_COLORS.get(mineral_type, Color.WHITE)
		_body_material.emission_enabled = true
		_body_material.emission = Color.WHITE
		_body_material.emission_energy_multiplier = 2.0
		var tween: Tween = create_tween()
		tween.tween_interval(0.1)
		tween.tween_callback(func(): _body_material.emission_energy_multiplier = 0.0)
	
	var tween_pos: Tween = create_tween()
	tween_pos.tween_property(mesh, "position:x", mesh.position.x + 0.05, 0.05)
	tween_pos.tween_property(mesh, "position:x", mesh.position.x, 0.05)

func _destroy() -> void:
	is_depleted = true
	destroyed.emit(self)
	var tween: Tween = create_tween()
	tween.tween_property(mesh, "scale", Vector3.ZERO, 0.2)
	tween.tween_callback(queue_free)
