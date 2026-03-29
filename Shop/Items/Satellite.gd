class_name Satellite
extends Node2D

signal energy_harvested(amount: float)


var type_name: String = "satellite"
var orbit_logic: OrbitLogic
var variance: float = 0.2
var base_center: Vector2 = Vector2.ZERO
var base_radius: float = 50.0
var base_orbit_speed: float = 0.1

var energy_timer: float = 0.0
var base_color: Color
var glow_color: Color = Color(1.2, 1.5, 0.5)

func item_purchased(player: Player):
	energy_harvested.connect(player.add_energy)
	await self.ready


func _ready():
	base_color = modulate
	energy_timer = Economy.get_total_energy_harvest_speed()
	orbit_logic = OrbitLogic.new(
		self, base_center, randomize_orbit(base_radius), randomize_orbit(base_orbit_speed)
	)
	add_child(orbit_logic)


func _process(delta):
	if energy_timer > 0:
		energy_timer -= delta

	if energy_timer <= 0:
		var total_energy = Economy.get_total_energy_bonus()
		energy_timer = Economy.get_total_energy_harvest_speed()
		emit_signal("energy_harvested", total_energy)
		var income_text = FloatingText.new(str("%0.2f" % [total_energy]))
		add_child(income_text)


func overcharge():
	modulate = glow_color


func end_overcharge():
	modulate = base_color


func randomize_orbit(value) -> float:
	return value * randf_range(1.0 - variance, 1.0 + variance)
