extends Node

## TransitionManager - Maneja transiciones entre escenas
##
## Proporciona funciones para cambiar entre superficie y cueva
## con transiciones suaves.

## ─── Señales ──────────────────────────────────────────
signal transition_started
signal transition_completed

## ─── Estado ───────────────────────────────────────────
var is_transitioning: bool = false
var current_scene: String = ""

## ─── Escenas ──────────────────────────────────────────
var scenes: Dictionary = {
	"surface": "res://scenes/environment/surface.tscn",
	"cave": "res://scenes/main/main.tscn"
}

## ─── Métodos Públicos ─────────────────────────────────
func go_to_scene(scene_name: String) -> void:
	if is_transitioning:
		return
	
	if not scenes.has(scene_name):
		push_error("Escena no encontrada: " + scene_name)
		return
	
	is_transitioning = true
	transition_started.emit()
	
	get_tree().change_scene_to_file(scenes[scene_name])
	
	is_transitioning = false
	transition_completed.emit()

func go_to_surface() -> void:
	go_to_scene("surface")

func go_to_cave() -> void:
	go_to_scene("cave")
