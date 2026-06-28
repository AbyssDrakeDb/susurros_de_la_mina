class_name MineralResource
extends Resource

## ─── Identificación ───────────────────────────────────
@export var mineral_id: String = ""
@export var display_name: String = ""

## ─── Stats ────────────────────────────────────────────
@export var health: int = 100
@export var mining_damage: int = 10
@export var yield_amount: Vector2i = Vector2i(1, 3)

## ─── Economía ────────────────────────────────────────
@export var sell_price: int = 5
@export var buy_price: int = 10

## ─── Rareza ──────────────────────────────────────────
enum Rarity { COMMON, UNCOMMON, RARE, VERY_RARE, LEGENDARY }
@export var rarity: Rarity = Rarity.COMMON

## ─── Visual ──────────────────────────────────────────
@export var mesh: PackedScene
@export var color: Color = Color.WHITE

## ─── Aparición ───────────────────────────────────────
@export_range(0, 10) var depth_min: int = 0
@export_range(0, 10) var depth_max: int = 10
@export_range(0.0, 10.0) var spawn_weight: float = 1.0
@export_range(0.0, 1.0) var battery_drop_chance: float = 0.15
