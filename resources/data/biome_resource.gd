class_name BiomeResource
extends Resource

## ─── Identificación ───────────────────────────────────
@export var biome_id: String = ""
@export var display_name: String = ""

## ─── Profundidad ─────────────────────────────────────
@export_range(0, 10) var depth_min: int = 0
@export_range(0, 10) var depth_max: int = 10

## ─── Visual ──────────────────────────────────────────
@export var ambient_color: Color = Color(0.5, 0.5, 0.5)
@export_range(0.0, 2.0) var ambient_energy: float = 0.5
@export var fog_color: Color = Color(0.2, 0.2, 0.2)
@export_range(0.0, 0.1) var fog_density: float = 0.02

## ─── Audio ───────────────────────────────────────────
@export var music_track: AudioStream
@export var ambient_sfx: Array[AudioStream] = []

## ─── Contenido ──────────────────────────────────────
@export var mineral_table: Array[MineralSpawnEntry] = []
@export var room_templates: Array[RoomTemplate] = []
@export var room_scenes: Array[PackedScene] = []
@export var tunnel_scene: PackedScene

## ─── Gameplay ────────────────────────────────────────
@export_range(0.0, 1.0) var hazard_chance: float = 0.1
