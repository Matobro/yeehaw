extends Node2D

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
	var dir = DirAccess.open("res://Items/Database/")

	if dir == null:
		push_error("Failed to open directory")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and not file_name.begins_with("."):
			if file_name.ends_with(".tres"):
				var path = "res://Items/Database/" + file_name
				var item = load(path) as ItemData

				if item != null:
					items.append(item)
					shop_add_item(item)

		file_name = dir.get_next()

	dir.list_dir_end()


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

	## Money stuff
	if !has_funds(player_energy, item_price):
		return

	player.energy -= item_price
	player.update_money()
	shop_button.item_purchased()

	# Deployable
	if item_type == 0:
		## Spawn item
		var item_scene: PackedScene = shop_button.item_scene
		var new_item = item_scene.instantiate()
		add_child(new_item)
		new_item.item_purchased(player)

	# PowerUp
	elif item_type == 1:
		var power_up_type: PowerUp.Type = shop_button.power_up_type
		var power_up_amount: float = shop_button.power_up_amount
		Economy.add_power_up(power_up_type, power_up_amount)


func has_funds(energy, price) -> bool:
	return energy >= price
