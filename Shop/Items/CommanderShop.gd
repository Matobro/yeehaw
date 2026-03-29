extends Node2D

var item_files = [
	"res://Shop/Perks/Database/Economist.tres",
	"res://Shop/Perks/Database/FleetAdmiral.tres",
	"res://Shop/Perks/Database/OrbitalEngineer.tres",
	"res://Shop/Perks/Database/Scholar.tres",
	"res://Shop/Perks/Database/Pirate.tres"
]

var shop_button_scene: PackedScene = preload("res://Shop/Items/ShopButton.tscn")
var items: Array[ItemData] = []
var all_shop_buttons: Array[ShopButton] = []

@onready var perk_list: GridContainer = $"../PlanetScene/UI/COMMANDERTAB/Content/Control/PerkShop/ShopItems"


func _ready():
	for path in item_files:
		var item = load(path) as ItemData
		if item:
			items.append(item)
			_add_shop_button(item)


func _add_shop_button(item: ItemData):
	var btn = shop_button_scene.instantiate() as ShopButton
	btn.initialize_shop_item(item)

	if item.item_category == 3:
		perk_list.add_child(btn)

	btn.shop_button_pressed.connect(_on_shop_item_purchased)
	all_shop_buttons.append(btn)


func _on_shop_item_purchased(button: ShopButton):
	var player: Player = PlayerManager.player
	var price: float = button.item_data.get_price()

	if player.available_perk_points < price or not button.item_data.meets_requirements():
		return

	var success: bool = false

	# deployable
	if button.item_data.item_type == 0:
		var instance = button.item_data.item_scene.instantiate()
		add_child(instance)
		instance.item_purchased(player)
		success = true

	# powerup
	elif button.item_data.item_type == 1:
		success = Economy.add_power_up(button.item_data.power_up_type, button.item_data.power_up_amount)

	if success:
		player.available_perk_points -= round(price)
		player.update_perk_points()
		button.item_purchased()
		_update_shop_buttons()
		Shop._update_shop_buttons()


func _update_shop_buttons():
	for btn in all_shop_buttons:
		btn.update_item_data()



func get_item_name(item_id: String) -> String:
	for item in items:
		if item.id == item_id:
			return item.item_name
	return item_id
