extends Node

## AudioManager - Gestión centralizada de audio
##
## Maneja Ambient, Music, SFX y Voice con pools de reproducción.

## ─── Configuración ───────────────────────────────────
const MAX_SFX_PLAYERS: int = 8

## ─── Nodos de Audio ──────────────────────────────────
var ambient_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var sfx_pool: Array[AudioStreamPlayer] = []
var voice_player: AudioStreamPlayer

## ─── Estado ──────────────────────────────────────────
var current_ambient: AudioStream = null
var current_music: AudioStream = null

## ─── Inicialización ──────────────────────────────────

func _ready() -> void:
	_setup_audio_players()

func _setup_audio_players() -> void:
	# Ambient player
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = &"Master"
	add_child(ambient_player)

	# Music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = &"Master"
	add_child(music_player)

	# SFX pool
	for i in MAX_SFX_PLAYERS:
		var player = AudioStreamPlayer.new()
		player.bus = &"Master"
		add_child(player)
		sfx_pool.append(player)

	# Voice player
	voice_player = AudioStreamPlayer.new()
	voice_player.bus = &"Master"
	add_child(voice_player)

## ─── Ambient ─────────────────────────────────────────

func play_ambient(stream: AudioStream, fade_time: float = 1.0) -> void:
	if stream == current_ambient and ambient_player.playing:
		return

	current_ambient = stream

	if ambient_player.playing:
		var tween = create_tween()
		tween.tween_property(ambient_player, "volume_db", -80.0, fade_time / 2.0)
		await tween.finished

	ambient_player.stream = stream
	ambient_player.volume_db = 0.0
	ambient_player.play()

	var tween = create_tween()
	tween.tween_property(ambient_player, "volume_db", 0.0, fade_time / 2.0)

func stop_ambient(fade_time: float = 1.0) -> void:
	if not ambient_player.playing:
		return

	var tween = create_tween()
	tween.tween_property(ambient_player, "volume_db", -80.0, fade_time)
	await tween.finished
	ambient_player.stop()
	current_ambient = null

## ─── Music ───────────────────────────────────────────

func play_music(stream: AudioStream, fade_time: float = 2.0) -> void:
	if stream == current_music and music_player.playing:
		return

	current_music = stream

	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_time / 2.0)
		await tween.finished

	music_player.stream = stream
	music_player.volume_db = 0.0
	music_player.play()

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0.0, fade_time / 2.0)

func stop_music(fade_time: float = 2.0) -> void:
	if not music_player.playing:
		return

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, fade_time)
	await tween.finished
	music_player.stop()
	current_music = null

## ─── SFX ─────────────────────────────────────────────

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if stream == null:
		return

	var player = _get_free_sfx_player()
	if player == null:
		return

	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()

func play_sfx_varied(stream: AudioStream, volume_db: float = 0.0,
		pitch_range: Vector2 = Vector2(0.9, 1.1)) -> void:
	var pitch = randf_range(pitch_range.x, pitch_range.y)
	play_sfx(stream, volume_db, pitch)

## ─── Voice ───────────────────────────────────────────

func play_voice(stream: AudioStream) -> void:
	if voice_player.playing:
		voice_player.stop()

	voice_player.stream = stream
	voice_player.play()

func stop_voice() -> void:
	if voice_player.playing:
		voice_player.stop()

## ─── Utilidades ──────────────────────────────────────

func set_master_volume(volume: float) -> void:
	var bus_idx = AudioServer.get_bus_index(&"Master")
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(clampf(volume, 0.0, 1.0)))

func set_sfx_volume(volume: float) -> void:
	# Crear bus SFX si no existe
	_ensure_sfx_bus()
	var bus_idx = AudioServer.get_bus_index(&"SFX")
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(clampf(volume, 0.0, 1.0)))

func set_music_volume(volume: float) -> void:
	_ensure_music_bus()
	var bus_idx = AudioServer.get_bus_index(&"Music")
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(clampf(volume, 0.0, 1.0)))

## ─── Métodos Privados ────────────────────────────────

func _get_free_sfx_player() -> AudioStreamPlayer:
	for player in sfx_pool:
		if not player.playing:
			return player
	# Reemplazar el más antiguo
	return sfx_pool[0]

func _ensure_sfx_bus() -> void:
	if AudioServer.get_bus_index(&"SFX") < 0:
		var bus_idx = AudioServer.bus_count
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, &"SFX")
		AudioServer.set_bus_send(bus_idx, &"Master")

func _ensure_music_bus() -> void:
	if AudioServer.get_bus_index(&"Music") < 0:
		var bus_idx = AudioServer.bus_count
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, &"Music")
		AudioServer.set_bus_send(bus_idx, &"Master")
