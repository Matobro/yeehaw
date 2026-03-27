extends Node2D

var item_files = [
	"res://Items/Database/PatrolHQ.tres",
	"res://Items/Database/PointDefenceTurret.tres",
	"res://Items/Database/TargetingSoftware.tres",
	"res://Items/Database/ShieldBooster.tres",
	"res://Items/Database/Generator.tres",
	"res://Items/Database/Relay Station.tres",
	"res://Items/Database/Satellite.tres",
	"res://Items/Database/FirmwareUpdate.tres",
	"res://Items/Database/SolarPlating.tres",
	"res://Items/Database/StellarMirror.tres",
	"res://Items/Database/Autocannon.tres"
]

var shop_button_scene: PackedScene = preload("res://ShopButton.tscn")

var items: Array[ItemData]

@onready
var economy_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/EconomyShop/ShopItems"
@onready
var defence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/DefenceShop/ShopItems"
@onready
var offence_shop_list: GridContainer = $"../PlanetScene/UI/UITAB/Content/Control/OffenceShop/ShopItems"


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


func shop_item_purchased(shop_button: ShopButton):
	var player: Player = PlayerManager.player
	var player_energy: float = player.energy
	var item_type: int = shop_button.item_type
	var item_price: float = shop_button.item_price
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


func has_funds(energy, price) -> bool:
	return energy >= price
