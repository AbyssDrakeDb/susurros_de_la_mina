extends Node
class_name BiomeSelectorClass

## ─── Configuración de biomas por profundidad ─────────
const BIOME_DEPTH_MAP: Dictionary = {
	0: "surface",
	1: "shallow", 2: "shallow", 3: "shallow",
	4: "crystal", 5: "crystal",
	6: "abandoned", 7: "abandoned",
	8: "deep", 9: "deep",
	10: "cursed",
}

## ─── Rutas de biomas ──────────────────────────────────
const BIOME_PATHS: Dictionary = {
	"surface": "res://resources/data/biomes/surface.tres",
	"shallow": "res://resources/data/biomes/shallow.tres",
	"crystal": "res://resources/data/biomes/crystal.tres",
	"abandoned": "res://resources/data/biomes/abandoned.tres",
	"deep": "res://resources/data/biomes/deep.tres",
	"cursed": "res://resources/data/biomes/cursed.tres",
}

## ─── Cache ────────────────────────────────────────────
var _biome_cache: Dictionary = {}

## ─── Métodos Públicos ────────────────────────────────
func get_biome_at_depth(depth: int) -> BiomeResource:
	var biome_id: String = BIOME_DEPTH_MAP.get(depth, "shallow")
	return _load_biome(biome_id)

func get_biome_id_at_depth(depth: int) -> String:
	return BIOME_DEPTH_MAP.get(depth, "shallow")

func get_current_biome() -> BiomeResource:
	return get_biome_at_depth(GameState.current_depth)

## ─── Métodos Privados ────────────────────────────────
func _load_biome(biome_id: String) -> BiomeResource:
	if _biome_cache.has(biome_id):
		return _biome_cache[biome_id]
	
	var path: String = BIOME_PATHS.get(biome_id, "")
	if path.is_empty():
		push_error("BiomeSelector: Bioma no encontrado: " + biome_id)
		return null
	
	var biome: BiomeResource = load(path) as BiomeResource
	if biome == null:
		push_error("BiomeSelector: Error cargando bioma: " + path)
		return null
	
	_biome_cache[biome_id] = biome
	return biome
