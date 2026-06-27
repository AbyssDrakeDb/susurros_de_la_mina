extends Control
class_name Hotbar

## ─── Configuración ───────────────────────────────────
@export var slot_count: int = 5

## ─── Nodos ────────────────────────────────────────────
@onready var slots_container: HBoxContainer = $SlotsContainer

## ─── Colores por tipo de mineral ──────────────────────
var mineral_colors: Dictionary = {
	"copper": Color(0.8, 0.4, 0.2),
	"iron": Color(0.5, 0.5, 0.55),
	"silver": Color(0.8, 0.8, 0.9),
	"gold": Color(1.0, 0.84, 0.0),
	"crystal": Color(0.4, 0.8, 1.0)
}

## ─── Godot Callbacks ──────────────────────────────────
func _ready() -> void:
	_create_slots()
	await get_tree().process_frame
	await get_tree().process_frame
	GameState.inventory_changed.connect(_on_inventory_changed)
	_update_display()

## ─── Métodos Privados ─────────────────────────────────
func _create_slots() -> void:
	if slots_container == null:
		return
	
	for child in slots_container.get_children():
		child.queue_free()
	
	for i in range(slot_count):
		var slot: PanelContainer = PanelContainer.new()
		slot.custom_minimum_size = Vector2(60, 60)
		
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.15, 0.8)
		style.border_color = Color(0.3, 0.3, 0.3)
		style.border_width_left = 2
		style.border_width_right = 2
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_left = 4
		style.corner_radius_bottom_right = 4
		slot.add_theme_stylebox_override("panel", style)
		
		var vbox: VBoxContainer = VBoxContainer.new()
		vbox.name = "VBoxContainer"
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var color_rect: ColorRect = ColorRect.new()
		color_rect.name = "ColorRect"
		color_rect.custom_minimum_size = Vector2(40, 40)
		color_rect.color = Color.TRANSPARENT
		
		var count_label: Label = Label.new()
		count_label.name = "CountLabel"
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		count_label.add_theme_font_size_override("font_size", 14)
		count_label.text = "0"
		
		vbox.add_child(color_rect)
		vbox.add_child(count_label)
		slot.add_child(vbox)
		slots_container.add_child(slot)

func _update_display() -> void:
	if slots_container == null:
		return
	
	var minerals: Array = GameState.inventory.keys()
	var slots: Array = slots_container.get_children()
	
	for i in range(slots.size()):
		var slot: PanelContainer = slots[i]
		var vbox: VBoxContainer = slot.get_node_or_null("VBoxContainer")
		if vbox == null:
			continue
		var color_rect: ColorRect = vbox.get_node_or_null("ColorRect")
		var count_label: Label = vbox.get_node_or_null("CountLabel")
		
		if i < minerals.size():
			var mineral_type: String = minerals[i]
			var amount: int = GameState.inventory[mineral_type]
			
			if color_rect:
				color_rect.color = mineral_colors.get(mineral_type, Color.WHITE)
			if count_label:
				count_label.text = str(amount)
		else:
			if color_rect:
				color_rect.color = Color.TRANSPARENT
			if count_label:
				count_label.text = "0"

func _on_inventory_changed() -> void:
	_update_display()
