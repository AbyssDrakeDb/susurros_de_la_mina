extends Node
class_name PickaxeTool

## ─── Señales ──────────────────────────────────────────
signal tool_used
signal tool_upgraded(new_type: String)

## ─── Configuración ───────────────────────────────────
@export var tool_type: String = "pickaxe_basic"
@export var base_damage: int = 25
@export var cooldown: float = 0.5
@export var noise_level: float = 1.0

## ─── State ────────────────────────────────────────────
var _cooldown_timer: float = 0.0
var _is_on_cooldown: bool = false

## ─── Tool Stats ───────────────────────────────────────
var TOOL_STATS: Dictionary = {
	"pickaxe_basic": {
		"damage": 25,
		"cooldown": 0.5,
		"noise": 1.0,
		"name": "Pico Básico"
	},
	"pickaxe_reinforced": {
		"damage": 40,
		"cooldown": 0.4,
		"noise": 1.2,
		"name": "Pico Reforzado"
	},
	"pickaxe_silent": {
		"damage": 25,
		"cooldown": 0.5,
		"noise": 0.5,
		"name": "Pico Silencioso"
	},
	"drill_manual": {
		"damage": 60,
		"cooldown": 0.3,
		"noise": 2.0,
		"name": "Taladro Manual"
	}
}

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	_apply_tool_stats()

func _process(delta: float) -> void:
	if _is_on_cooldown:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0:
			_is_on_cooldown = false

## ─── Public Methods ───────────────────────────────────
func can_use() -> bool:
	return not _is_on_cooldown

func use(target: Node3D) -> bool:
	if not can_use():
		return false
	
	if target == null:
		return false
	
	if target.has_method("take_damage"):
		target.take_damage(base_damage, tool_type)
		_start_cooldown()
		tool_used.emit()
		return true
	
	return false

func upgrade(new_type: String) -> void:
	if TOOL_STATS.has(new_type):
		tool_type = new_type
		_apply_tool_stats()
		tool_upgraded.emit(new_type)

func get_info() -> Dictionary:
	return {
		"type": tool_type,
		"damage": base_damage,
		"cooldown": cooldown,
		"noise": noise_level,
		"name": TOOL_STATS.get(tool_type, {}).get("name", "Unknown")
	}

## ─── Private Methods ──────────────────────────────────
func _apply_tool_stats() -> void:
	var stats: Dictionary = TOOL_STATS.get(tool_type, {})
	base_damage = stats.get("damage", 25)
	cooldown = stats.get("cooldown", 0.5)
	noise_level = stats.get("noise", 1.0)

func _start_cooldown() -> void:
	_is_on_cooldown = true
	_cooldown_timer = cooldown
