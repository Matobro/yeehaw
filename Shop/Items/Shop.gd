extends Node2D


var item_files = [
	"res://Shop/Items/Database/PatrolHQ.tres",
	"res://Shop/Items/Database/PointDefenceTurret.tres",
	"res://Shop/Items/Database/TargetingSoftware.tres",
	"res://Shop/Items/Database/ShieldBooster.tres",
	"res://Shop/Items/Database/Generator.tres",
	"res://Shop/Items/Database/Relay Station.tres",
	"res://Shop/Items/Database/Satellite.tres",
	"res://Shop/Items/Database/FirmwareUpdate.tres",
	"res://Shop/Items/Database/SolarPlating.tres",
	"res://Shop/Items/Database/StellarMirror.tres",
	"res://Shop/Items/Database/Autocannon.tres",
	"res://Shop/Items/Database/Ammo Upgrade.tres"
]

var shop_button_scene: PackedScene = preload("res://Shop/Items/ShopButton.tscn")
var items: Array[ItemData] = []
var all_shop_buttons: Array[ShopButton] = []
var deployed_items := {}


@onready var economy_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/EconomyShop/ShopItems"
@onready var defence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/DefenceShop/ShopItems"
@onready var offence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/OffenceShop/ShopItems"


func _ready():
	for path in item_files:
		var item = load(path) as ItemData
		if item:
			items.append(item)
			_add_shop_button(item)


func _add_shop_button(item: ItemData):
	var btn = shop_button_scene.instantiate() as ShopButton
	btn.initialize_shop_item(item)
	match item.item_category:
		0: economy_shop_list.add_child(btn)
		1: defence_shop_list.add_child(btn)
		2: offence_shop_list.add_child(btn)

	btn.shop_button_pressed.connect(_on_shop_item_purchased)
	all_shop_buttons.append(btn)


func _on_shop_item_purchased(button: ShopButton):
	var player: Player = PlayerManager.player
	var price: float = button.current_price

	if player.energy < price or !button.item_data.meets_requirements():
		return

	var success: bool = false

	if button.item_data.item_type == 0: # deployable
		var instance = button.item_data.item_scene.instantiate()
		add_child(instance)
		_add_deployed_item(instance)
		instance.item_purchased(player)
		success = true

	elif button.item_data.item_type == 1: # powerup
		success = Economy.add_power_up(button.item_data.power_up_type, button.item_data.power_up_amount)

	if success:
		player.energy -= price
		player.update_money()
		button.item_purchased()
		_update_shop_buttons()


func _add_deployed_item(item):
	var t = item.type_name
	if not deployed_items.has(t):
		deployed_items[t] = []
	deployed_items[t].append(item)


func get_deployed_items_by_type(type_name: String) -> Array:
	return deployed_items.get(type_name, [])


func _update_shop_buttons():
	for btn in all_shop_buttons:
		btn.update_item_data()


func get_items_by_subcategory(subcat: int) -> Array:
	var result: Array = []
	for item in items:
		if item.item_sub_category == subcat:
			result.append(item)
	return result


func get_items_names_by_subcategory(subcat: int) -> String:
	var names: Array = []
	for item in get_items_by_subcategory(subcat):
		names.append(item.item_name)
	return ", ".join(names)


func get_item_name(item_id: String) -> String:
	for item in items:
		if item.id == item_id:
			return item.item_name
	return item_id
