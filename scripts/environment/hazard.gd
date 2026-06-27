extends Area3D
class_name Hazard

## ─── Configuración ───────────────────────────────────
@export var damage_amount: int = 10
@export var damage_interval: float = 1.0

## ─── Estado ───────────────────────────────────────────
var is_player_inside: bool = false
var damage_timer: float = 0.0

## ─── Nodos ────────────────────────────────────────────
@onready var label: Label3D = $Label3D

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if label:
		label.visible = false

func _process(delta: float) -> void:
	if is_player_inside:
		damage_timer -= delta
		if damage_timer <= 0.0:
			_apply_damage()
			damage_timer = damage_interval

## ─── Métodos Privados ─────────────────────────────────
func _apply_damage() -> void:
	GameState.take_damage(damage_amount)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_inside = true
		damage_timer = 0.0
		if label:
			label.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_inside = false
		if label:
			label.visible = false
