class_name ShipFactory
extends Node2D

@export var built_ship: ShipStats


var type_name: String = "patrol_hq"
var orbit_logic: OrbitLogic
var variance: float = 0.2
var base_center: Vector2 = Vector2.ZERO
var base_radius: float = 200.0
var base_orbit_speed: float = 0.05

var building_timer: float = 0.0

var ships: Array[Ship]

func item_purchased(player: Player):
	await self.ready


func _ready():
	orbit_logic = OrbitLogic.new(
		self, base_center, randomize_orbit(base_radius), randomize_orbit(base_orbit_speed)
	)
	add_child(orbit_logic)	
	building_timer = Economy.get_ship_building_speed()


func _process(delta):
	building_timer -= delta

	if building_timer <= 0:
		if ships.size() >= Economy.get_max_ship_count():
			return

		building_timer = Economy.get_ship_building_speed()
		var new_ship = ShipManager.create_ship(built_ship, 1, global_position)
		ships.append(new_ship)

		new_ship.ship_destroyed.connect(on_ship_destroyed)


func randomize_orbit(value) -> float:
	return value * randf_range(1.0 - variance, 1.0 + variance)


func on_ship_destroyed(ship: Ship):
	ships.erase(ship)