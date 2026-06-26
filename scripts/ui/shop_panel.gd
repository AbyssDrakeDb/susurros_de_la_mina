extends Control
class_name ShopPanel

## ─── Señales ──────────────────────────────────────────
signal upgrade_purchased(upgrade: String, cost: int)
signal shop_closed

## ─── Nodos ────────────────────────────────────────────
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var upgrade_list: VBoxContainer = $VBoxContainer/ScrollContainer/UpgradeList
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var gold_label: Label = $VBoxContainer/GoldLabel

## ─── Mejoras disponibles ──────────────────────────────
var upgrades: Dictionary = {
	"backpack_upgrade": {
		"name": "Mochila Mayor",
		"description": "+10 capacidad de inventario",
		"cost": 100,
		"purchased": false
	},
	"pickaxe_damage": {
		"name": "Pico Reforzado",
		"description": "+10 daño de minero",
		"cost": 150,
		"purchased": false
	},
	"battery_upgrade": {
		"name": "Batería Mejorada",
		"description": "+50% duración de batería",
		"cost": 80,
		"purchased": false
	},
	"speed_upgrade": {
		"name": "Botas de Velocidad",
		"description": "+20% velocidad de movimiento",
		"cost": 120,
		"purchased": false
	}
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
	
	if upgrade_list:
		for child in upgrade_list.get_children():
			child.queue_free()
		
		for upgrade_id in upgrades:
			var upgrade: Dictionary = upgrades[upgrade_id]
			var is_purchased: bool = upgrade["purchased"]
			var can_afford: bool = GameState.gold >= upgrade["cost"]
			
			var row: HBoxContainer = HBoxContainer.new()
			
			var info_vbox: VBoxContainer = VBoxContainer.new()
			info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			var name_label: Label = Label.new()
			name_label.text = upgrade["name"]
			name_label.theme_override_font_sizes/font_size = 18
			
			var desc_label: Label = Label.new()
			desc_label.text = upgrade["description"]
			desc_label.theme_override_font_sizes/font_size = 14
			
			var cost_label: Label = Label.new()
			cost_label.text = "Costo: %d oro" % upgrade["cost"]
			cost_label.theme_override_font_sizes/font_size = 14
			
			info_vbox.add_child(name_label)
			info_vbox.add_child(desc_label)
			info_vbox.add_child(cost_label)
			
			var buy_button: Button = Button.new()
			if is_purchased:
				buy_button.text = "Comprado"
				buy_button.disabled = true
			elif can_afford:
				buy_button.text = "Comprar"
				buy_button.pressed.connect(_on_buy_pressed.bind(upgrade_id))
			else:
				buy_button.text = "Sin oro"
				buy_button.disabled = true
			
			row.add_child(info_vbox)
			row.add_child(buy_button)
			upgrade_list.add_child(row)

func _on_buy_pressed(upgrade_id: String) -> void:
	var upgrade: Dictionary = upgrades[upgrade_id]
	if GameState.spend_gold(upgrade["cost"]):
		upgrade["purchased"] = true
		GameState.unlock_upgrade(upgrade_id)
		_apply_upgrade(upgrade_id)
		upgrade_purchased.emit(upgrade_id, upgrade["cost"])
		_update_display()

func _apply_upgrade(upgrade_id: String) -> void:
	match upgrade_id:
		"backpack_upgrade":
			GameState.inventory_capacity += 10
		"pickaxe_damage":
			pass
		"battery_upgrade":
			pass
		"speed_upgrade":
			pass

func _on_close_pressed() -> void:
	visible = false
	shop_closed.emit()

func _on_gold_changed(new_gold: int) -> void:
	_update_display()
