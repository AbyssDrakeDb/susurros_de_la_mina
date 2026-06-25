extends Node

## SaveManager - Persistencia de datos del juego
##
## Guarda y carga el estado del juego en un archivo binario.

## ─── Constantes ──────────────────────────────────────
const SAVE_PATH: String = "user://savegame.dat"
const SETTINGS_PATH: String = "user://settings.cfg"
const SAVE_VERSION: int = 1

## ─── Señales ──────────────────────────────────────────
signal game_saved
signal game_loaded
signal save_error(error_message: String)

## ─── Métodos Públicos ────────────────────────────────

func save_game() -> bool:
	var save_data = {
		"version": SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"player": {
			"depth": GameState.current_depth,
			"max_depth": GameState.max_depth_reached,
			"health": GameState.health,
			"max_health": GameState.max_health,
			"energy": GameState.energy,
			"max_energy": GameState.max_energy,
			"gold": GameState.gold,
		},
		"inventory": GameState.inventory.duplicate(),
		"inventory_capacity": GameState.inventory_capacity,
		"flags": GameState.flags.duplicate(),
		"upgrades": GameState.unlocked_upgrades.duplicate(),
		"horror_phase": GameState.horror_phase,
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var error_msg = "No se pudo crear archivo de guardado: " + SAVE_PATH
		push_error(error_msg)
		save_error.emit(error_msg)
		return false

	file.store_var(save_data)
	file.close()
	game_saved.emit()
	print("[SaveManager] Juego guardado exitosamente")
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveManager] No existe archivo de guardado")
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		var error_msg = "No se pudo leer archivo de guardado: " + SAVE_PATH
		push_error(error_msg)
		save_error.emit(error_msg)
		return false

	var save_data = file.get_var()
	file.close()

	# Verificar versión
	if not save_data.has("version"):
		save_error.emit("Formato de guardado inválido")
		return false

	if save_data.version > SAVE_VERSION:
		save_error.emit("Versión de guardado no compatible")
		return false

	# Restaurar estado del jugador
	var player_data = save_data.player
	GameState.current_depth = player_data.depth
	GameState.max_depth_reached = player_data.max_depth
	GameState.health = player_data.health
	GameState.max_health = player_data.max_health
	GameState.energy = player_data.energy
	GameState.max_energy = player_data.max_energy
	GameState.gold = player_data.gold

	# Restaurar inventario
	GameState.inventory = save_data.inventory.duplicate()
	GameState.inventory_capacity = save_data.inventory_capacity
	GameState._update_inventory_used()

	# Restaurar progresión
	GameState.flags = save_data.flags.duplicate()
	GameState.unlocked_upgrades = save_data.upgrades.duplicate()
	GameState.horror_phase = save_data.horror_phase

	# Emitir señales para actualizar UI
	GameState.health_changed.emit(GameState.health)
	GameState.energy_changed.emit(GameState.energy)
	GameState.gold_changed.emit(GameState.gold)
	GameState.depth_changed.emit(GameState.current_depth)
	GameState.inventory_changed.emit()

	game_loaded.emit()
	print("[SaveManager] Juego cargado exitosamente desde: ", save_data.timestamp)
	return true

func delete_save() -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		var error = DirAccess.remove_absolute(SAVE_PATH)
		if error != OK:
			push_error("No se pudo eliminar archivo de guardado")
			return false
		print("[SaveManager] Archivo de guardado eliminado")
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func get_save_info() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}

	var save_data = file.get_var()
	file.close()

	return {
		"version": save_data.get("version", 0),
		"timestamp": save_data.get("timestamp", ""),
		"depth": save_data.get("player", {}).get("depth", 0),
		"gold": save_data.get("player", {}).get("gold", 0),
	}

## ─── Configuración ───────────────────────────────────

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master", GameState.master_volume)
	config.set_value("audio", "sfx", GameState.sfx_volume)
	config.set_value("audio", "music", GameState.music_volume)
	config.set_value("controls", "mouse_sensitivity", GameState.mouse_sensitivity)
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return

	GameState.master_volume = config.get_value("audio", "master", 1.0)
	GameState.sfx_volume = config.get_value("audio", "sfx", 1.0)
	GameState.music_volume = config.get_value("audio", "music", 1.0)
	GameState.mouse_sensitivity = config.get_value("controls", "mouse_sensitivity", 0.002)
