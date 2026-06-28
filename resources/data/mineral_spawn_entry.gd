class_name MineralSpawnEntry
extends Resource

## ─── Referencia al mineral ───────────────────────────
@export var mineral: MineralResource

## ─── Configuración de spawn ──────────────────────────
@export_range(0.0, 100.0) var weight: float = 1.0
@export_range(0, 20) var min_count: int = 1
@export_range(0, 20) var max_count: int = 3
