extends Node3D

## Main - Escena principal del juego
##
## Punto de entrada del juego. Maneja el estado inicial
## y la transición entre pantallas.

## ─── Nodos ────────────────────────────────────────────
@onready var world_environment: WorldEnvironment = $WorldEnvironment

## ─── Godot Callbacks ──────────────────────────────────

func _ready() -> void:
	print("[Main] Iniciando Susurros de la Mina...")
	_setup_environment()
	GameState.change_phase(GameState.GamePhase.MENU)

## ─── Métodos Privados ────────────────────────────────

func _setup_environment() -> void:
	# Configurar WorldEnvironment para tono oscuro
	var env = Environment.new()

	# Fondo
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.05, 0.05, 0.08)

	# Tono
	env.tonemap_mode = Environment.TONE_MAP_ACES

	# Niebla
	env.fog_enabled = true
	env.fog_light_color = Color(0.1, 0.1, 0.15)
	env.fog_density = 0.02

	# SSAO
	env.ssao_enabled = true
	env.ssao_radius = 1.0
	env.ssao_intensity = 2.0

	# Postprocesado
	env.glow_enabled = true
	env.glow_intensity = 0.3

	world_environment.environment = env
