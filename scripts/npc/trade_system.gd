extends Node
class_name TradeSystem

## ─── Señales ──────────────────────────────────────────
signal trade_completed(item: String, amount: int, gold: int)
signal trade_failed(reason: String)

## ─── Precios de minerales ─────────────────────────────
var mineral_prices: Dictionary = {
	"copper": 10,
	"iron": 25,
	"silver": 50,
	"gold": 100,
	"crystal": 200
}

## ─── Métodos Públicos ─────────────────────────────────
func sell_mineral(mineral_type: String, amount: int = 1) -> bool:
	if not GameState.inventory.has(mineral_type):
		trade_failed.emit("No tienes " + mineral_type)
		return false
	
	var available: int = GameState.inventory[mineral_type]
	if available < amount:
		trade_failed.emit("No tienes suficiente " + mineral_type)
		return false
	
	var price_per_unit: int = mineral_prices.get(mineral_type, 0)
	if price_per_unit <= 0:
		trade_failed.emit("No se puede vender " + mineral_type)
		return false
	
	var total_gold: int = price_per_unit * amount
	
	GameState.remove_mineral(mineral_type, amount)
	GameState.add_gold(total_gold)
	
	trade_completed.emit(mineral_type, amount, total_gold)
	return true

func get_price(mineral_type: String) -> int:
	return mineral_prices.get(mineral_type, 0)

func get_all_prices() -> Dictionary:
	return mineral_prices.duplicate()
