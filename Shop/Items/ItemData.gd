extends Resource
class_name ItemData

@export var id: String = ""
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
@export_multiline var item_description: String

@export_category("Requirements")
@export var requirements: Array[Requirement]

@export_category("Unlocks")
@export var has_unlock: bool = false
@export var amount_required: int = 0
@export var unlock_type: Unlock.Type
@export_multiline var unlock_text: String


func meets_requirements() -> bool:
	return Progression.meets_all(requirements)

func get_price() -> float:
	match item_sub_category:
		1: return item_base_price * Economy.orbital_price_multiplier
		_: return item_base_price

func format_description(amount_owned: int = 0) -> String:
	var formatted: String = item_description

	if has_unlock and amount_owned >= amount_required:
		formatted = formatted.replace("{unlock_line}", "")
	else:
		formatted = formatted.replace("{unlock_line}", unlock_text)

	var replacements = {
		"{value}": "%d%%" % int(power_up_amount * 100),
		"{value2}": "%0.1f%%" % (power_up_amount * 100),
		"{flat}": str(power_up_amount),
		"{total_energy}": "%0.1f" % Economy.get_total_energy_bonus(),
		"{harvest_speed}": "%0.1f" % Economy.get_total_energy_harvest_speed(),
		"{economist_bonus}": "%d%%" % int((Economy.get_energy_total_multiplier_bonus() * 100) - 100.0),
		"{max_shield}": "%0.1f" % Economy.get_max_shield(),
		"{shield_delay}": "%0.1f" % Economy.get_shield_regeneration_delay(),
		"{regeneration_amount}": "%0.1f" % Economy.get_shield_regeneration_amount(),
		"{regeneration_speed}": "%0.1f" % Economy.get_shield_regeneration_speed(),
		"{energy_flat_bonus}": "%0.1f" % Economy.get_energy_flat_bonus(),
		"{energy_multiplier}": "%d%%" % int((Economy.get_energy_multiplier() * 100) - 100.0),
		"{satellite_production}": "%0.1f" % (Economy.get_energy_per_second() * amount_owned),
		"{pd_speed}": "%0.1f" % Economy.get_point_defence_speed(),
		"{max_ships}": str(Economy.get_max_ship_count()),
		"{orbital_price}": "%0.1f" % (Economy.get_orbital_price_multiplier() * 100),
		"{orbital_items}": Shop.get_items_names_by_subcategory(1),
		"{orbital_min_price}": "%d%%" % (Economy.get_orbital_price_multiplier_min() * 100),
		"{unlock_at}": str(amount_required),
		"{defence_turret_damage}": "%0.1f" % Economy.get_defence_turret_damage()
	}

	for key in replacements.keys():
		formatted = formatted.replace(key, replacements[key])

	return formatted


func format_requirements() -> String:
	if requirements.is_empty():
		return ""
	
	var req_texts := []
	for req in requirements:
		var text := ""
		var current := 0
		var required := req.required_amount
		var name := ""
		var color := "red"

		match req.type:
			Requirement.Type.UNLOCK:
				# 1 if unlocked, 0 if not
				current = 1 if req.unlock_type in Progression.unlocks else 0
				name = str(req.unlock_type)

			Requirement.Type.ITEM_COUNT:
				current = Progression.item_counts.get(req.item_id, 0)
				name = Shop.get_item_name(req.item_id)

			Requirement.Type.PERK_LEVEL:
				current = Progression.perk_levels.get(req.perk_id, 0)
				name = CommanderShop.get_item_name(req.perk_id)

			Requirement.Type.PLAYER_LEVEL:
				current = PlayerManager.player.level
				name = "Commander Level"

		if current >= required:
			color = "green"

		text = "%d / %d [color=%s]%s[/color]" % [current, required, color, name]
		req_texts.append(text)

	return "Requires:\n" + "\n".join(req_texts)
