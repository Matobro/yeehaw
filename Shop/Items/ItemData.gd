class_name ItemData
extends Resource

@export_enum("Economy", "Defence", "Offence", "Perk") var item_category: int
@export_enum("Misc", "Orbital") var item_sub_category: int
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


@export_category("Unlocks")
@export var has_unlock: bool = false
@export var amount_required: int = 0
@export var unlock_type: Unlock.Type
@export_multiline var unlock_text: String