extends Node

var base_energy_harvest: float = 1.0 # flat amount
var energy_multiplier: float = 1.0  # percentage multiplier
var energy_flat_bonus: float = 0.0  # flat multiplier
var energy_harvest_speed: float = 5.0 # in seconds
var energy_harvest_bonus: float = 0.0
var energy_total_multiplier_bonus: float = 1.0
var energy_overcharge_bonus: float = 1.0

var shield_max: float = 100.0
var shield_regeneration_delay: float = 5.0 # in seconds
var shield_regeneration_delay_min: float = 0.1
var shield_regeneration_amount: float = 1.0
var shield_regeneration_speed: float = 1.0 # in seconds
var shield_regeneration_speed_min: float = 0.1
var shield_regeneration_speed_multiplier: float = 1.0

var ship_building_speed: float = 1.0 # in seconds
var max_ship_amount: int = 10 # per building

var point_defence_speed: float = 2.0 # in seconds
var point_defence_speed_min: float = 0.1

var defence_turret_speed: float = 1.0
var defence_turret_speed_min: float = 0.1

var defence_turret_damage: float = 1.0
var defence_turret_bullet_speed: float = 200.0

var orbital_price_multiplier: float = 1.0
var orbital_price_multiplier_min: float = 0.05

var experience_multiplier: float = 1.0
var loot_energy_multiplier: float = 1.0

func add_power_up(type: PowerUp.Type, amount: float) -> bool:
	var success: bool = true

	match type:
		PowerUp.Type.ENERGY_MULTIPLIER:
			energy_multiplier += amount
		PowerUp.Type.ENERGY_FLAT_BONUS:
			energy_flat_bonus += amount
		PowerUp.Type.ENERGY_HARVEST_SPEED:
			energy_harvest_bonus += amount
		PowerUp.Type.MAX_SHIELD:
			shield_max += amount
			PlayerManager.get_planet().get_force_field().on_shield_value_changed()
		PowerUp.Type.SHIELD_DELAY:
			if shield_regeneration_delay > shield_regeneration_delay_min:
				shield_regeneration_delay = clampf(shield_regeneration_delay - amount, shield_regeneration_delay_min, shield_regeneration_delay)
			else: success = false
		PowerUp.Type.SHIELD_REGENERATION:
			shield_regeneration_amount += amount
		PowerUp.Type.SHIELD_SPEED:
			if shield_regeneration_speed > shield_regeneration_speed_min:
				shield_regeneration_speed = clampf(shield_regeneration_speed - amount, shield_regeneration_speed_min, shield_regeneration_speed)
			else: success = false
		PowerUp.Type.PD_SPEED:
			if point_defence_speed > point_defence_speed_min:
				point_defence_speed = clampf(point_defence_speed - amount, point_defence_speed_min, point_defence_speed)
			else: success = false
		PowerUp.Type.ENERGY_TOTAL_MULTIPLIER_BONUS:
			energy_total_multiplier_bonus += amount
		PowerUp.Type.MAX_SHIPS:
			max_ship_amount += round(amount)
		PowerUp.Type.ORBITAL_PRICE_DECREASE:
			if orbital_price_multiplier > orbital_price_multiplier_min:
				orbital_price_multiplier = clampf(orbital_price_multiplier - amount, orbital_price_multiplier_min, orbital_price_multiplier)
			else:
				success = false
		PowerUp.Type.DEFENCE_TURRET_DAMAGE:
			defence_turret_damage += 1
		PowerUp.Type.EXPERIENCE_MULTIPLIER:
			experience_multiplier += amount
		PowerUp.Type.LOOT_ENERGY_MULTIPLIER:
			loot_energy_multiplier += amount

		_:
			success = false

	return success


func add_energy_multiplier(amount):
	energy_multiplier += amount


func get_energy_multiplier() -> float:
	return energy_multiplier


func get_energy_flat_bonus() -> float:
	return energy_flat_bonus


func get_total_energy_bonus() -> float:
	return (((base_energy_harvest + energy_flat_bonus) * energy_multiplier) * energy_total_multiplier_bonus) * energy_overcharge_bonus


func get_total_energy_harvest_speed() -> float:
	return energy_harvest_speed / (1.0 + energy_harvest_bonus)


func get_energy_per_second() -> float:
	var energy_per_harvest = get_total_energy_bonus()
	var harvests_per_second = 1.0 / get_total_energy_harvest_speed()
	return energy_per_harvest * harvests_per_second


func get_energy_total_multiplier_bonus() -> float:
	return energy_total_multiplier_bonus


func get_shield_regeneration_delay() -> float:
	return shield_regeneration_delay


func get_shield_regeneration_delay_min() -> float:
	return shield_regeneration_delay_min


func get_shield_regeneration_amount() -> float:
	return shield_regeneration_amount


func get_shield_regeneration_speed() -> float:
	return shield_regeneration_speed


func get_max_shield() -> float:
	return shield_max


func get_ship_building_speed() -> float:
	return ship_building_speed


func get_max_ship_count() -> int:
	return max_ship_amount


func get_point_defence_speed() -> float:
	return point_defence_speed


func get_point_defence_speed_min() -> float:
	return point_defence_speed_min


func get_defence_turret_speed() -> float:
	return defence_turret_speed


func get_defence_turret_speed_min() -> float:
	return defence_turret_speed_min


func get_defence_turret_damage() -> float:
	return defence_turret_damage


func get_defence_turret_bullet_speed() -> float:
	return defence_turret_bullet_speed


func get_orbital_price_multiplier() -> float:
	return orbital_price_multiplier


func get_orbital_price_multiplier_min() -> float:
	return orbital_price_multiplier_min


func get_experience_multiplier() -> float:
	return experience_multiplier


func get_loot_energy_multiplier() -> float:
	return loot_energy_multiplier