extends Control
class_name TradePanel

## ─── Señales ──────────────────────────────────────────
signal item_sold(item: String, amount: int, gold: int)
signal trade_closed

## ─── Nodos ────────────────────────────────────────────
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var mineral_list: VBoxContainer = $VBoxContainer/ScrollContainer/MineralList
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var gold_label: Label = $VBoxContainer/GoldLabel

## ─── Precios ──────────────────────────────────────────
var mineral_prices: Dictionary = {
	"copper": 10,
	"iron": 25,
	"silver": 50,
	"gold": 100,
	"crystal": 200
}

var mineral_colors: Dictionary = {
	"copper": Color(0.8, 0.4, 0.2),
	"iron": Color(0.5, 0.5, 0.55),
	"silver": Color(0.8, 0.8, 0.9),
	"gold": Color(1.0, 0.84, 0.0),
	"crystal": Color(0.4, 0.8, 1.0)
}

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	close_button.pressed.connect(_on_close_pressed)
	GameState.gold_changed.connect(_on_gold_changed)
	_update_display()

## ─── Métodos Públicos ─────────────────────────────────
func _update_display() -> void:
	if gold_label:
		gold_label.text = "Oro: %d" % GameState.gold
	
	if mineral_list:
		for child in mineral_list.get_children():
			child.queue_free()
		
		for mineral_type in GameState.inventory:
			var amount: int = GameState.inventory[mineral_type]
			var price: int = mineral_prices.get(mineral_type, 0)
			
			var row: HBoxContainer = HBoxContainer.new()
			
			var color_rect: ColorRect = ColorRect.new()
			color_rect.custom_minimum_size = Vector2(20, 20)
			color_rect.color = mineral_colors.get(mineral_type, Color.WHITE)
			
			var name_label: Label = Label.new()
			name_label.text = mineral_type.capitalize()
			name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			var amount_label: Label = Label.new()
			amount_label.text = "x%d" % amount
			
			var price_label: Label = Label.new()
			price_label.text = "%d oro" % (price * amount)
			
			var sell_button: Button = Button.new()
			sell_button.text = "Vender"
			sell_button.pressed.connect(_on_sell_pressed.bind(mineral_type, amount))
			
			row.add_child(color_rect)
			row.add_child(name_label)
			row.add_child(amount_label)
			row.add_child(price_label)
			row.add_child(sell_button)
			mineral_list.add_child(row)

func _on_sell_pressed(mineral_type: String, amount: int) -> void:
	var price_per_unit: int = mineral_prices.get(mineral_type, 0)
	var total_gold: int = price_per_unit * amount
	
	if GameState.remove_mineral(mineral_type, amount):
		GameState.add_gold(total_gold)
		item_sold.emit(mineral_type, amount, total_gold)
		_update_display()

func _on_close_pressed() -> void:
	visible = false
	trade_closed.emit()

func _on_gold_changed(new_gold: int) -> void:
	if gold_label:
		gold_label.text = "Oro: %d" % new_gold
