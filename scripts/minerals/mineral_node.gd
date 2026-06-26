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

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	current_health = max_health
	_setup_visual()

## ─── Public Methods ───────────────────────────────────
func take_damage(amount: int, tool_type: String = "pickaxe") -> void:
	if is_depleted:
		return
	
	var damage_modifier: float = _get_tool_modifier(tool_type)
	var final_damage: int = int(amount * damage_modifier)
	
	current_health -= final_damage
	health_changed.emit(current_health)
	
	_play_hit_animation()
	
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
func _setup_visual() -> void:
	if mesh.get_surface_override_material(0) != null:
		return
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = _get_mineral_color()
	mesh.material_override = material

func _get_mineral_color() -> Color:
	match mineral_type:
		"copper": return Color(0.8, 0.4, 0.2)
		"iron": return Color(0.5, 0.5, 0.5)
		"silver": return Color(0.8, 0.8, 0.9)
		"gold": return Color(1.0, 0.84, 0.0)
		"crystal": return Color(0.4, 0.8, 1.0)
		_: return Color.WHITE

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
	set_deferred("collision_layer", 0)
	AudioManager.play_sfx_varied(preload("res://assets/audio/sfx/mining/impactMining_002.ogg"))
