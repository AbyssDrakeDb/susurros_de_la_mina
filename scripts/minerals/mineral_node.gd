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

## ─── Visual Feedback ─────────────────────────────────
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var health_bar_3d: Node3D = $HealthBar3D
@onready var health_fill: MeshInstance3D = $HealthBar3D/HealthFill
@onready var health_label: Label3D = $HealthBar3D/HealthLabel

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	current_health = max_health
	_update_health_bar()

## ─── Public Methods ───────────────────────────────────
func take_damage(amount: int, tool_type: String = "pickaxe") -> void:
	if is_depleted:
		return
	
	var damage_modifier: float = _get_tool_modifier(tool_type)
	var final_damage: int = int(amount * damage_modifier)
	
	current_health -= final_damage
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

## ─── Private Methods ──────────────────────────────────
func _update_health_bar() -> void:
	if health_bar_3d == null:
		return
	
	var health_percent: float = float(current_health) / float(max_health)
	
	# Escalar barra de vida
	if health_fill:
		health_fill.scale.x = health_percent
	
	# Cambiar color según salud
	if health_fill:
		var mat: StandardMaterial3D = health_fill.get_surface_override_material(0)
		if mat == null:
			mat = StandardMaterial3D.new()
			health_fill.material_override = mat
		
		if health_percent > 0.6:
			mat.albedo_color = Color(0.2, 0.8, 0.2)  # Verde
		elif health_percent > 0.3:
			mat.albedo_color = Color(0.8, 0.8, 0.2)  # Amarillo
		else:
			mat.albedo_color = Color(0.8, 0.2, 0.2)  # Rojo
	
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
	var tween: Tween = create_tween()
	tween.tween_property(mesh, "position:x", mesh.position.x + 0.05, 0.05)
	tween.tween_property(mesh, "position:x", mesh.position.x, 0.05)

func _destroy() -> void:
	is_depleted = true
	destroyed.emit(self)
	mesh.visible = false
	if health_bar_3d:
		health_bar_3d.visible = false
	set_deferred("collision_layer", 0)
