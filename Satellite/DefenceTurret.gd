class_name DefenceTurret
extends Node2D

@export var bullet_scene: PackedScene
var orbit_logic: OrbitLogic
var variance: float = 0.01
var base_center: Vector2 = Vector2.ZERO
var base_radius: float = 100.0
var base_orbit_speed: float = 0.025

var fire_timer: float = 0.0

func item_purchased(player: Player):
	await self.ready


func _ready():
	fire_timer = 0.0
	orbit_logic = OrbitLogic.new(
		self, base_center, randomize_orbit(base_radius), randomize_orbit(base_orbit_speed)
	)
	add_child(orbit_logic)


func _process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		shoot()
		fire_timer = Economy.get_defence_turret_speed()


func shoot():
	var planet: Planet = PlayerManager.get_planet()
	var alarm_area: AlarmArea = planet.get_alarm_area()

	var targeted_enemy: Ship = alarm_area.get_random_enemy_in_area()

	if targeted_enemy == null:
		fire_timer = 0.0
		return

	var new_bullet: Bullet = bullet_scene.instantiate()
	var damage = Economy.get_defence_turret_damage()
	var speed = Economy.get_defence_turret_speed()
	var bullet_speed = Economy.get_defence_turret_bullet_speed()
	var bullet_scale = Vector2(0.2, 0.2)

	fire_timer = speed

	new_bullet.global_position = global_position

	var distance_vector = targeted_enemy.global_position - global_position
	var distance = distance_vector.length()

	var target_velocity = Vector2.ZERO
	if targeted_enemy.has_method("get_velocity"):
		target_velocity = targeted_enemy.get_velocity()
		
	var travel_time = distance / bullet_speed

	var predicted_pos = targeted_enemy.global_position + target_velocity * travel_time
	var direction = (predicted_pos - global_position).normalized()
	new_bullet.scale = bullet_scale
	new_bullet.modulate = Color(0, 3, 0)
	new_bullet.initialize_bullet(damage, bullet_speed, null, direction)

	look_at(predicted_pos)
	rotation += deg_to_rad(90)
	get_tree().current_scene.add_child(new_bullet)

func randomize_orbit(value) -> float:
	return value * randf_range(1.0 - variance, 1.0 + variance)
