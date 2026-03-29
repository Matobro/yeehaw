extends Control
class_name ShopButton

signal shop_button_pressed(button: ShopButton)

@export var button: Button
@export var item_name_label: Label
@export var item_price_label: Label
@export var item_icon: TextureRect
@export var tool_tip: PanelContainer
@export var tool_tip_label: RichTextLabel
@export var amount_owned_label: Label
@export var disabled_panel: Panel

var item_data: ItemData
var amount_owned: int = 0
var unlocked: bool = false


func initialize_shop_item(_item_data: ItemData):
	item_data = _item_data
	if item_data.item_icon == null:
		item_data.item_icon = Shop.missing_texture
	
	if item_data.item_category == 3:
		item_price_label.visible = false
	item_icon.texture = item_data.item_icon
	item_name_label.text = item_data.item_name
	item_price_label.text = str(item_data.get_price())
	tool_tip_label.text = item_data.format_description(amount_owned)
	item_data.item_current_price = item_data.item_base_price
	button.pressed.connect(_on_pressed)
	button.mouse_entered.connect(_on_mouse_hover_enter)
	button.mouse_exited.connect(_on_mouse_hover_exit)
	update_item_data()


func update_item_data():
	var available = item_data.meets_requirements()
	button.disabled = !available
	disabled_panel.visible = !available
	item_price_label.text = str("%0.1f" % item_data.get_price())
	tool_tip_label.text = item_data.format_description(amount_owned)

	if available:
		tool_tip_label.text = item_data.format_description(amount_owned)
	else:
		tool_tip_label.text = item_data.format_requirements()


func item_purchased():
	match item_data.item_category:
		3: # perk
			Progression.perk_levels[item_data.id] = Progression.perk_levels.get(item_data.id, 0) + 1
		_: # item
			Progression.add_item(item_data.id)
	amount_owned += 1
	amount_owned_label.text = str(amount_owned)
	item_data.increase_price()
	if item_data.has_unlock and amount_owned >= item_data.amount_required:
		Progression.add_unlock(item_data.unlock_type)
		unlocked = true

	update_item_data()


func _on_pressed():
	emit_signal("shop_button_pressed", self)


func _on_mouse_hover_enter():
	update_item_data()
	tool_tip.visible = true


func _on_mouse_hover_exit():
	tool_tip.visible = false
