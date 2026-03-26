class_name PointDefenceTurret
extends Node2D

var orbit_logic: OrbitLogic
var variance: float = 0.01
var base_center: Vector2 = Vector2.ZERO
var base_radius: float = 100.0
var base_orbit_speed: float = 0.025

var fire_timer: float = 0.0

func item_purchased(player: Player):
	await self.ready

func _ready():
	fire_timer = Economy.get_point_defence_speed()
	orbit_logic = OrbitLogic.new(
		self, base_center, randomize_orbit(base_radius), randomize_orbit(base_orbit_speed)
	)
	add_child(orbit_logic)


func _process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		shoot()
		fire_timer = Economy.get_point_defence_speed()


func shoot():
	var planet: Planet = PlayerManager.get_planet()
	var bullet_area: BulletArea = planet.get_bullet_area()

	if bullet_area.bullets_in_area.is_empty():
		fire_timer = 0.0
		return

	var intercepted_bullet: PlanetKillerBullet = bullet_area.get_random_bullet()

	if !is_instance_valid(intercepted_bullet) or intercepted_bullet == null:
		fire_timer = 0.0
		return

	var start_point = global_position
	var end_point = intercepted_bullet.global_position
	
	look_at(end_point)
	rotation += deg_to_rad(90)
	var laser = LaserEffect.new(start_point, end_point)
	add_child(laser)

	intercepted_bullet.queue_free()

func randomize_orbit(value) -> float:
	return value * randf_range(1.0 - variance, 1.0 + variance)
