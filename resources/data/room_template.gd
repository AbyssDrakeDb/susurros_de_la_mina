class_name RoomTemplate
extends Resource

## ─── Identificación ───────────────────────────────────
@export var room_id: String = ""

## ─── Escena ──────────────────────────────────────────
@export var scene: PackedScene

## ─── Tipo de sala ────────────────────────────────────
enum RoomType { ENTRANCE, MINERAL, STORY, CHALLENGE, BOSS }
@export var room_type: RoomType = RoomType.MINERAL

## ─── Bioma asociado ─────────────────────────────────
@export var biome: BiomeResource

## ─── Profundidad ─────────────────────────────────────
@export_range(0, 10) var min_depth: int = 0
@export_range(0, 10) var max_depth: int = 10

## ─── Peso de selección ──────────────────────────────
@export_range(0.0, 100.0) var weight: float = 1.0
