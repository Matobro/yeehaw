class_name StellarMirror
extends Node2D

var orbit_logic: OrbitLogic
var base_center: Vector2 = Vector2.ZERO
var base_radius: float = 300.0
var base_orbit_speed: float = 0.1

var energy_multiplier: float = 0.1


func item_purchased(_player: Player):
	Economy.add_energy_multiplier(energy_multiplier)
	await self.ready


func _ready():
	orbit_logic = OrbitLogic.new(self, base_center, base_radius, base_orbit_speed)
	add_child(orbit_logic)
