extends Node

var base_energy_harvest: float = 0.1
var energy_multiplier: float = 1.0  # percentage multiplier
var energy_flat_bonus: float = 0.0  # flat multiplier
var energy_harvest_speed: float = 5.0
var energy_harvest_bonus: float = 0.0

var shield_max: float = 10.0
var shield_regeneration_delay: float = 5.0
var shield_regeneration_amount: float = 0.1
var shield_regeneration_speed: float = 1.0


func add_power_up(type: PowerUp.Type, amount: float):
	match type:
		PowerUp.Type.ENERGY_MULTIPLIER:
			energy_multiplier += amount
		PowerUp.Type.ENERGY_FLAT_BONUS:
			energy_flat_bonus += amount
		PowerUp.Type.ENERGY_HARVEST_SPEED:
			energy_harvest_bonus += amount
		PowerUp.Type.MAX_SHIELD:
			shield_max += amount
		PowerUp.Type.SHIELD_DELAY:
			shield_regeneration_delay -= amount
		PowerUp.Type.SHIELD_REGENERATION:
			shield_regeneration_amount += amount
		_:
			pass


func add_energy_multiplier(amount):
	energy_multiplier += amount


func get_energy_multiplier() -> float:
	return energy_multiplier


func get_energy_flat_bonus() -> float:
	return energy_flat_bonus


func get_total_energy_bonus() -> float:
	return (base_energy_harvest + energy_flat_bonus) * energy_multiplier


func get_total_energy_harvest_speed() -> float:
	return energy_harvest_speed / (1.0 + energy_harvest_bonus)


func get_energy_per_second() -> float:
	var energy_per_harvest = get_total_energy_bonus()
	var harvests_per_second = 1.0 / get_total_energy_harvest_speed()
	return energy_per_harvest * harvests_per_second


func get_shield_regeneration_delay() -> float:
	return shield_regeneration_delay


func get_shield_regeneration_amount() -> float:
	return shield_regeneration_amount


func get_shield_regeneration_speed() -> float:
	return shield_regeneration_speed


func get_max_shield() -> float:
	return shield_max
