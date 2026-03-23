class_name ItemData
extends Resource

@export_enum("Economy", "Defence", "Offence") var item_category: int
@export_enum("Deployable", "PowerUp") var item_type: int

@export_category("PowerUp")
@export var power_up_type: PowerUp.Type
@export var power_up_amount: float

@export_category("Deployable")
@export var item_scene: PackedScene

@export_category("Item stats")
@export var item_icon: Texture2D
@export var item_base_price: float
@export var item_name: String
@export var price_scaling: float = 1.1
## {value} for percentage {flat} for flat value {total_energy} total energy with bonuses
@export_multiline var item_description: String
