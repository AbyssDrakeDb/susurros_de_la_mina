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
@export var battery_drop_chance: float = 0.15

## ─── Distancia para mostrar/ocultar label ─────────────
@export var label_show_distance: float = 3.0
@export var label_hide_distance: float = 1.5

## ─── State ────────────────────────────────────────────
var current_health: int
var is_depleted: bool = false

## ─── Materiales únicos por instancia ──────────────────
var _body_material: StandardMaterial3D
var _healthbar_fill_material: StandardMaterial3D

## ─── Referencias ─────────────────────────────────────
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
	_update_health_bar()
	if health_label:
		health_label.visible = false
	mined.connect(_on_mined)

func _process(_delta: float) -> void:
	if is_depleted or health_label == null:
		return
	
	var player: Node3D = get_tree().get_first_node_in_group("player")
	if player == null:
		health_label.visible = false
		return
	
	var dist: float = global_position.distance_to(player.global_position)
	health_label.visible = dist <= label_show_distance and dist >= label_hide_distance

## ─── Private Methods ──────────────────────────────────
func _create_unique_materials() -> void:
	_body_material = StandardMaterial3D.new()
	_body_material.albedo_color = MINERAL_COLORS.get(mineral_type, Color.WHITE)
	mesh.material_override = _body_material
	
	_healthbar_fill_material = StandardMaterial3D.new()
	_healthbar_fill_material.albedo_color = Color(0.2, 0.8, 0.2)
	if health_fill:
		health_fill.material_override = _healthbar_fill_material
	
	if health_bar_3d:
		var bg: MeshInstance3D = health_bar_3d.get_node_or_null("HealthBarBG")
		if bg:
			var bg_mat: StandardMaterial3D = StandardMaterial3D.new()
			bg_mat.albedo_color = Color(0.1, 0.1, 0.1)
			bg.material_override = bg_mat

func _update_health_bar() -> void:
	if health_bar_3d == null or _healthbar_fill_material == null:
		return
	
	var health_percent: float = float(current_health) / float(max_health)
	
	if health_fill:
		health_fill.scale.x = maxf(health_percent, 0.001)
		health_fill.position.x = -0.2 * (1.0 - health_percent)
	
	if health_percent > 0.6:
		_healthbar_fill_material.albedo_color = Color(0.2, 0.8, 0.2)
	elif health_percent > 0.3:
		_healthbar_fill_material.albedo_color = Color(0.8, 0.8, 0.2)
	else:
		_healthbar_fill_material.albedo_color = Color(0.8, 0.2, 0.2)
	
	if health_label:
		health_label.text = "%d" % current_health

func _get_tool_modifier(tool_type: String) -> float:
	match tool_type:
		"pickaxe_basic": return 1.0
		"pickaxe_reinforced": return 1.5
		"drill": return 2.0
		_: return 1.0

func _play_hit_animation() -> void:
	if _body_material:
		_body_material.emission_enabled = true
		_body_material.emission = Color.WHITE
		_body_material.emission_energy_multiplier = 3.0
		var tween: Tween = create_tween()
		tween.tween_interval(0.08)
		tween.tween_callback(func():
			if _body_material:
				_body_material.emission_energy_multiplier = 0.0
		)
	
	if health_bar_3d:
		var original_pos: Vector3 = health_bar_3d.position
		var tween_bar: Tween = create_tween()
		tween_bar.tween_property(health_bar_3d, "position:x", original_pos.x + 0.02, 0.03)
		tween_bar.tween_property(health_bar_3d, "position:x", original_pos.x - 0.02, 0.03)
		tween_bar.tween_property(health_bar_3d, "position:x", original_pos.x, 0.03)

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

func _destroy() -> void:
	is_depleted = true
	destroyed.emit(self)
	if health_bar_3d:
		health_bar_3d.visible = false
	var tween: Tween = create_tween()
	tween.tween_property(mesh, "scale", Vector3.ZERO, 0.15)
	tween.tween_callback(queue_free)

func _on_mined(_node: MineralNode, amount: int) -> void:
	GameState.add_mineral(mineral_type, amount)
	
	if randf() < battery_drop_chance:
		GameState.add_battery(1)
