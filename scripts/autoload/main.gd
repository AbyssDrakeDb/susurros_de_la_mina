extends Node3D

## Main - Escena principal del juego
##
## Punto de entrada del juego. Maneja el estado inicial
## y la transición entre pantallas.

## ─── Godot Callbacks ──────────────────────────────────

func _ready() -> void:
	print("[Main] Iniciando Susurros de la Mina...")
	GameState.change_phase(GameState.GamePhase.PLAYING)
