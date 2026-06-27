extends Node
class_name GameStateClass

## ─── Señales ──────────────────────────────────────────
signal phase_changed(new_phase: GamePhase)
signal horror_phase_changed(new_horror_phase: HorrorPhase)
signal depth_changed(new_depth: int)
signal mineral_changed(mineral_type: String, new_amount: int)
signal health_changed(new_health: int)
signal energy_changed(new_energy: int)
signal gold_changed(new_gold: int)
signal inventory_changed
signal flag_set(flag_name: String, value: bool)

## ─── Enums ────────────────────────────────────────────
enum GamePhase {
	MENU,
	PLAYING,
	PAUSED,
	INVENTORY,
	SHOPPING,
	GAME_OVER
}

enum HorrorPhase {
	NONE,
	LATENT,
	STALKING,
	HUNTING
}

## ─── Estado del Jugador ──────────────────────────────
var current_phase: GamePhase = GamePhase.MENU
var horror_phase: HorrorPhase = HorrorPhase.NONE

var current_depth: int = 0
var max_depth_reached: int = 0

var health: int = 100
var max_health: int = 100

var energy: int = 100
var max_energy: int = 100

## ─── Inventario ──────────────────────────────────────
var inventory: Dictionary = {}
var inventory_capacity: int = 20
var inventory_used: int = 0

## ─── Economía ────────────────────────────────────────
var gold: int = 0

## ─── Items especiales ─────────────────────────────────
var battery_cells: int = 0

## ─── Progresión ──────────────────────────────────────
var flags: Dictionary = {}
var unlocked_upgrades: Array[String] = []

## ─── Configuración ───────────────────────────────────
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0
var mouse_sensitivity: float = 0.002

## ─── Métodos Públicos ────────────────────────────────

func change_phase(new_phase: GamePhase) -> void:
	current_phase = new_phase
	phase_changed.emit(new_phase)

func change_horror_phase(new_horror_phase: HorrorPhase) -> void:
	horror_phase = new_horror_phase
	horror_phase_changed.emit(new_horror_phase)

func add_mineral(mineral_type: String, amount: int = 1) -> bool:
	var current_amount = inventory.get(mineral_type, 0)
	var new_total = current_amount + amount

	if inventory_used + amount > inventory_capacity:
		return false

	inventory[mineral_type] = new_total
	_update_inventory_used()
	mineral_changed.emit(mineral_type, new_total)
	inventory_changed.emit()
	return true

func remove_mineral(mineral_type: String, amount: int = 1) -> bool:
	var current_amount = inventory.get(mineral_type, 0)

	if current_amount < amount:
		return false

	var new_total = current_amount - amount
	if new_total <= 0:
		inventory.erase(mineral_type)
	else:
		inventory[mineral_type] = new_total

	_update_inventory_used()
	mineral_changed.emit(mineral_type, new_total)
	inventory_changed.emit()
	return true

func get_mineral_count(mineral_type: String) -> int:
	return inventory.get(mineral_type, 0)

func change_depth(new_depth: int) -> void:
	current_depth = new_depth
	if new_depth > max_depth_reached:
		max_depth_reached = new_depth
	depth_changed.emit(new_depth)

func take_damage(amount: int) -> void:
	health = clampi(health - amount, 0, max_health)
	health_changed.emit(health)
	if health <= 0:
		_handle_death()

func heal(amount: int) -> void:
	health = clampi(health + amount, 0, max_health)
	health_changed.emit(health)

func use_energy(amount: int) -> bool:
	if energy < amount:
		return false
	energy = clampi(energy - amount, 0, max_energy)
	energy_changed.emit(energy)
	return true

func restore_energy(amount: int) -> void:
	energy = clampi(energy + amount, 0, max_energy)
	energy_changed.emit(energy)

func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)

func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	gold_changed.emit(gold)
	return true

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value
	flag_set.emit(flag_name, value)

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func unlock_upgrade(upgrade_name: String) -> void:
	if not unlocked_upgrades.has(upgrade_name):
		unlocked_upgrades.append(upgrade_name)

func has_upgrade(upgrade_name: String) -> bool:
	return unlocked_upgrades.has(upgrade_name)

func get_damage_bonus() -> int:
	if has_upgrade("pickaxe_damage"):
		return 10
	return 0

func get_speed_multiplier() -> float:
	if has_upgrade("speed_upgrade"):
		return 1.2
	return 1.0

func get_battery_multiplier() -> float:
	if has_upgrade("battery_upgrade"):
		return 1.5
	return 1.0

func add_battery(amount: int = 1) -> void:
	battery_cells += amount
	inventory_changed.emit()

func use_battery() -> bool:
	if battery_cells <= 0:
		return false
	battery_cells -= 1
	inventory_changed.emit()
	return true

func reset_state() -> void:
	health = max_health
	energy = max_energy
	gold = 0
	inventory.clear()
	flags.clear()
	unlocked_upgrades.clear()
	current_depth = 0
	max_depth_reached = 0
	horror_phase = HorrorPhase.NONE
	change_phase(GamePhase.PLAYING)

## ─── Métodos Privados ────────────────────────────────

func _update_inventory_used() -> void:
	inventory_used = 0
	for mineral_type in inventory:
		inventory_used += inventory[mineral_type]

func _get_max_stack() -> int:
	return 99

func _handle_death() -> void:
	lose_random_items()
	change_phase(GamePhase.GAME_OVER)

func lose_random_items() -> void:
	var items_to_lose: int = randi_range(1, 3)
	var mineral_types: Array = inventory.keys()
	mineral_types.shuffle()
	
	for i in range(mini(items_to_lose, mineral_types.size())):
		var mineral_type: String = mineral_types[i]
		var amount_to_lose: int = randi_range(1, inventory[mineral_type])
		remove_mineral(mineral_type, amount_to_lose)
