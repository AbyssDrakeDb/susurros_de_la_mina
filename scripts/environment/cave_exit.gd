extends Area3D
class_name CaveExit

## ─── Configuración ───────────────────────────────────
@export var target_scene: String = "surface"

## ─── Estado ───────────────────────────────────────────
var is_player_inside: bool = false

## ─── Nodos ────────────────────────────────────────────
@onready var label: Label3D = $Label3D

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_inside:
		_exit_cave()

## ─── Métodos Privados ─────────────────────────────────
func _exit_cave() -> void:
	MineGenerator.clear_all_chunks()
	MineGenerator.chunk_manager.chunk_container = null
	GameState.change_depth(0)
	TransitionManager.go_to_scene(target_scene)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_inside = true
		if label:
			label.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_inside = false
		if label:
			label.visible = false
