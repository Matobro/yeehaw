extends Node

var test_ship: ShipStats = preload("res://Ships/Database/TestShip.tres")
var ship_scene: PackedScene = preload("res://Ships/ShipScene.tscn")

var dev_spawn_timer: float = 0.0
var dev_spawn_time: float = 1.5

var dev_spawn_enabled: bool = true

var dev_wave_timer: float
var dev_wave_ships_timer: float
var dev_wave_time: float = 60.0
var dev_wave_ships_time: float = 120.0

var ships_spawned: int = 1

func _ready() -> void:
	dev_wave_timer = dev_wave_time
	dev_wave_ships_timer = dev_wave_ships_time


func _physics_process(delta):
	if dev_spawn_enabled:
		dev_wave_timer -= delta
		dev_wave_ships_timer -= delta
		dev_spawn_timer -= delta
		if dev_wave_timer <= 0:
			dev_wave_timer = dev_wave_time
			dev_spawn_time = clampf(dev_spawn_time, 0.1, dev_spawn_time)

		if dev_wave_ships_timer <= 0:
			dev_wave_ships_timer = dev_wave_ships_time
			ships_spawned += 1

		if dev_spawn_timer <= 0:
			dev_spawn_timer = dev_spawn_time
			for i in range(ships_spawned):
				var angle = randi_range(0, 360)
				var distance = 1500
				var offset = Vector2(cos(angle), sin(angle)) * distance
				var pos = Vector2.ZERO + offset
				var new_ship: Ship = create_ship(test_ship, 2, pos)
				new_ship.get_node("Sprite").modulate = Color.RED


func create_ship(ship_stats: ShipStats, ship_team: int, pos: Vector2) -> Ship:
	var new_ship: Ship = ship_scene.instantiate()
	new_ship.global_position = pos
	new_ship._initialize_ship(ship_stats, ship_team)
	add_child(new_ship)
	return new_ship
