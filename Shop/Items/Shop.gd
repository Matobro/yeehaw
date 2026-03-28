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
	"res://Shop/Items/Database/Autocannon.tres"
]

var shop_button_scene: PackedScene = preload("res://Shop/Items/ShopButton.tscn")

var items: Array[ItemData]

@onready
var economy_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/EconomyShop/ShopItems"
@onready
var defence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/DefenceShop/ShopItems"
@onready
var offence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/OffenceShop/ShopItems"

var all_shop_buttons: Array[ShopButton]

func _ready():
	initialize_items()


func initialize_items():
	for path in item_files:
		var item = load(path) as ItemData
		if item != null:
			items.append(item)
			shop_add_item(item)


func shop_add_item(new_item: ItemData):
	var new_shop_button = shop_button_scene.instantiate()
	new_shop_button.initialize_shop_item(new_item)
	match new_item.item_category:
		0:  #economy
			economy_shop_list.add_child(new_shop_button)
		1:  #defence
			defence_shop_list.add_child(new_shop_button)
		2:  #offence
			offence_shop_list.add_child(new_shop_button)
	new_shop_button.shop_button_pressed.connect(shop_item_purchased)

	all_shop_buttons.append(new_shop_button)

func shop_item_purchased(shop_button: ShopButton):
	var player: Player = PlayerManager.player
	var player_energy: float = player.energy
	var item_type: int = shop_button.item_type
	var item_sub_category: int = shop_button.item_data.item_sub_category
	var price_multiplier: float
	match item_sub_category:
		# none/misc
		0:
			price_multiplier = 1.0
		1:
			price_multiplier = Economy.orbital_price_multiplier
		_:
			price_multiplier = 1.0

	var item_price: float = shop_button.item_price * price_multiplier
	var success: bool

	## Money stuff
	if !has_funds(player_energy, item_price):
		return

	# Deployable
	if item_type == 0:
		## Spawn item
		var item_scene: PackedScene = shop_button.item_scene
		var new_item = item_scene.instantiate()
		add_child(new_item)
		new_item.item_purchased(player)
		success = true

	# PowerUp
	elif item_type == 1:
		var power_up_type: PowerUp.Type = shop_button.power_up_type
		var power_up_amount: float = shop_button.power_up_amount

		# Some items are limited such as attack speed, its checked here if already at min
		success = Economy.add_power_up(power_up_type, power_up_amount)

	# If purchase made
	if success:
		player.energy -= item_price
		player.update_money()
		shop_button.item_purchased()


func force_update_shop():
	for i in range(all_shop_buttons.size()):
		var shop_button = all_shop_buttons[i]
		shop_button.update_item_data()


func has_funds(energy, price) -> bool:
	return energy >= price


func get_items_by_subcategory(subcat: int) -> Array[ItemData]:
	var result: Array = []
	for item in items:
		if item.item_sub_category == subcat:
			result.append(item)
	return result

func get_items_names_by_subcategory(subcat: int) -> String:
	var names: Array[String] = []
	for item in items:
		if item.item_sub_category == subcat:
			names.append(item.item_name)
	return ", ".join(names)
