class_name ShopButton
extends Control

signal shop_button_pressed(button: ShopButton)

@export var button: Button
@export var item_name_label: Label
@export var item_price_label: Label
@export var item_icon: TextureRect
@export var tool_tip: PanelContainer
@export var tool_tip_label: RichTextLabel
@export var amount_owned_label: Label

var item_data: ItemData
var item_type: int
var power_up_type: PowerUp.Type
var power_up_amount: float
var item_scene: PackedScene

var item_base_price: float
var item_name: String
var item_price: float
var price_scaling: float = 1.1
var current_price_scaling: float
var amount_owned: int


func initialize_shop_item(_item_data: ItemData):
	## Copy data from itemdata
	item_data = _item_data
	item_type = _item_data.item_type
	item_icon.texture = _item_data.item_icon
	power_up_type = _item_data.power_up_type
	power_up_amount = _item_data.power_up_amount
	item_scene = item_data.item_scene
	item_base_price = item_data.item_base_price
	item_name = item_data.item_name
	price_scaling = item_data.price_scaling

	## Set base data
	item_price = item_base_price
	current_price_scaling = price_scaling
	update_item_data()
	tool_tip_label.text = format_description(item_data.item_description)


func _ready():
	button.pressed.connect(on_button_pressed)
	button.mouse_entered.connect(on_mouse_hover_enter)
	button.mouse_exited.connect(on_mouse_hover_exit)

	## Todo
	if item_name == "Satellite":
		on_button_pressed()


func update_item_data():
	tool_tip_label.text = format_description(
		item_data.item_description,
	)
	item_name_label.text = item_name
	item_price_label.text = str("%.1f" % item_price)


func item_purchased():
	item_price = item_price * price_scaling
	amount_owned += 1
	amount_owned_label.text = str(amount_owned)
	await get_tree().physics_frame
	update_item_data()


func on_button_pressed():
	emit_signal("shop_button_pressed", self)


func on_mouse_hover_enter():
	update_item_data()
	tool_tip.visible = true


func on_mouse_hover_exit():
	tool_tip.visible = false


func format_description(text: String) -> String:
	return (
		text
		. replace("{value}", "%d%%" % int(power_up_amount * 100))
		. replace("{flat}", str(power_up_amount))
		. replace("{total_energy}", str("%0.1f" % Economy.get_total_energy_bonus()))
		. replace("{harvest_speed}", str("%0.1f" % Economy.get_total_energy_harvest_speed()))
		. replace("{max_shield}", str("%0.1f" % Economy.get_max_shield()))
		. replace("{shield_delay}", str("%0.1f" % Economy.get_shield_regeneration_delay()))\
		.replace("{regeneration_amount}", str("%0.1f" % Economy.get_shield_regeneration_amount()))
		. replace("{regeneration_speed}", str("%0.1f" % Economy.get_shield_regeneration_speed()))
		. replace("{energy_flat_bonus}", str("%0.1f" % Economy.get_energy_flat_bonus()))
		. replace("{energy_multiplier}", "%d%%" % int((Economy.get_energy_multiplier() * 100) - 100.0))
		. replace(
			"{satellite_production}",
			str("%0.1f" % (Economy.get_energy_per_second() * amount_owned))
		)\
		.replace("{pd_speed}", str("%0.1f" % Economy.get_point_defence_speed()))\
		.replace("{max_ships}", str(Economy.get_max_ship_count()))\
	)
