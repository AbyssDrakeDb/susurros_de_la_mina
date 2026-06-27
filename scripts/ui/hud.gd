extends CanvasLayer
class_name HUD

## ─── Nodos ────────────────────────────────────────────
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var battery_bar: ProgressBar = $MarginContainer/VBoxContainer/BatteryBar
@onready var mineral_counter: Label = $MarginContainer/VBoxContainer/MineralCounter
@onready var gold_counter: Label = $MarginContainer/VBoxContainer/GoldCounter
@onready var depth_label: Label = $MarginContainer/VBoxContainer/DepthLabel

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	GameState.health_changed.connect(_on_health_changed)
	GameState.gold_changed.connect(_on_gold_changed)
	GameState.depth_changed.connect(_on_depth_changed)
	GameState.mineral_changed.connect(_on_mineral_changed)
	GameState.inventory_changed.connect(_on_inventory_changed)
	_update_all()

## ─── Private Methods ──────────────────────────────────
func _update_all() -> void:
	health_bar.value = GameState.health
	gold_counter.text = "Gold: %d | Pilas: %d" % [GameState.gold, GameState.battery_cells]
	depth_label.text = "Depth: %dm" % GameState.current_depth
	_update_mineral_count()

func _update_mineral_count() -> void:
	var total: int = 0
	for mineral in GameState.inventory:
		total += GameState.inventory[mineral]
	mineral_counter.text = "Minerals: %d / %d" % [total, GameState.inventory_capacity]

func update_battery(battery: float) -> void:
	battery_bar.value = battery

## ─── Callbacks de GameState ────────────────────────────
func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func _on_gold_changed(new_gold: int) -> void:
	gold_counter.text = "Gold: %d | Pilas: %d" % [new_gold, GameState.battery_cells]

func _on_depth_changed(new_depth: int) -> void:
	depth_label.text = "Depth: %dm" % new_depth

func _on_mineral_changed(_mineral_type: String, _new_amount: int) -> void:
	_update_mineral_count()

func _on_inventory_changed() -> void:
	gold_counter.text = "Gold: %d | Pilas: %d" % [GameState.gold, GameState.battery_cells]
