extends Node2D

var item_files = [
	"res://Perks/Database/Economist.tres",
	"res://Perks/Database/FleetAdmiral.tres",
	"res://Perks/Database/OrbitalEngineer.tres"
]

var shop_button_scene: PackedScene = preload("res://ShopButton.tscn")

var items: Array[ItemData]

@onready
var perk_list: GridContainer = $"../PlanetScene/UI/COMMANDERTAB/Content/Control/PerkShop/ShopItems"


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
		3:  # perks
			perk_list.add_child(new_shop_button)
	new_shop_button.shop_button_pressed.connect(shop_item_purchased)


func shop_item_purchased(shop_button: ShopButton):
	var player: Player = PlayerManager.player
	var player_perk_points: float = player.available_perk_points
	var item_type: int = shop_button.item_type
	var item_price: float = shop_button.item_price
	var success: bool

	## Money stuff
	if !has_funds(player_perk_points, item_price):
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
		player.available_perk_points -= round(item_price)
		player.update_perk_points()
		shop_button.item_purchased()
		Shop.force_update_shop()


func has_funds(perk_points, price) -> bool:
	return perk_points >= round(price)
