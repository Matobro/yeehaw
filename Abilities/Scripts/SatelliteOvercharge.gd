class_name SatelliteOvercharge
extends Ability

var duration = 30.0
var ability_targets: Array

func _ready():
	ability_targets = Shop.get_deployed_items_by_type(PowerUp.TypeName.SATELLITE)
	for target in ability_targets:
		target.overcharge()

	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(end_ability)
	Economy.energy_overcharge_bonus = 3.0
	PlayerManager.get_planet().get_force_field().disabled = true


func end_ability():
	for target in ability_targets:
		target.end_overcharge()
	Economy.energy_overcharge_bonus = 1.0
	PlayerManager.get_planet().get_force_field().disabled = false
	call_deferred("queue_free")
