class_name Ship
extends CharacterBody2D

signal ship_destroyed(ship: Ship)

enum State { PATROL, FIGHT, FLEE, TRAVEL }

@export var hitbox: HitBox
@export var aggrobox: AggroBox
@export var ship_team: int = 1
@export var ship_sprite: Sprite2D
var stats: ShipStats

var current_state: State = State.PATROL
var state_update_speed: float = 1.0

var current_target: Node2D

var center = PlayerManager.planet.global_position

var state_timer: float = 0.0
var patrol_timer: float = 0.0

var move_direction: Vector2 = Vector2.ZERO
var attack_timer: float = 0.0
var planet_attack_timer: float = 0.0
var orbit_direction: int

var dead: bool = false

var spawn_origin: Node


func _initialize_ship(_stats: ShipStats, _ship_team: int):
	stats = _stats.duplicate(true)
	ship_team = _ship_team
	stats.current_health = stats.max_health
	velocity = Vector2.RIGHT * 10.0
	await ready
	aggrobox.ship_team = ship_team
	hitbox.ship_team = ship_team
	hitbox.origin = self
	aggrobox.origin = hitbox
	aggrobox.enemy_spotted.connect(on_enemy_spotted)
	hitbox.took_damage.connect(on_damage_taken)
	var aggro_radius: CircleShape2D = aggrobox.get_node("CollisionShape2D").shape
	aggro_radius.radius = stats.seek_range



func _physics_process(delta):
	if dead: return
	if planet_attack_timer > 0:
		planet_attack_timer -= delta

	if attack_timer > 0:
		attack_timer -= delta

	state_timer -= delta

	decide_action(delta)

	ship_sprite.rotation = move_direction.angle() + deg_to_rad(90)
	if state_timer <= 0:
		state_timer = state_update_speed


func on_damage_taken(amount):
	stats.current_health -= amount

	if stats.current_health <= 0:
		dead = true
		if ship_team != 1:
			var player = PlayerManager.get_player()
			player.add_energy(stats.energy_dropped)
			player.add_experience(stats.experience_dropped)
			
		emit_signal("ship_destroyed", self)
		call_deferred("queue_free")


func decide_action(delta):
	if current_state == null:
		current_state = State.PATROL

	match current_state:
		State.PATROL:
			patrol_state(delta)
		State.FIGHT:
			fight_state(delta)
		State.FLEE:
			flee_state()
		State.TRAVEL:
			travel_state(delta)


func on_alarm(enemy: Ship):
	if current_target == null:
		on_enemy_spotted(enemy)


func on_enemy_spotted(enemy: Node2D):
	current_target = enemy


func patrol_state(delta):
	if ship_team != 1:
		state_timer = 0
		current_state = State.TRAVEL
		return

	update_patrol(delta)

	if has_target(): 
		current_state = State.FIGHT 
		return
	
	var to_center = center - global_position
	var distance = to_center.length()
	
	var desired_direction = move_direction

	if distance > stats.patrol_radius:
		desired_direction = to_center.normalized()

	# Smooth direction change
	move_direction = move_direction.lerp(desired_direction.normalized(), 0.05)

	apply_movement()


func update_patrol(delta):
	patrol_timer -= delta
	
	if patrol_timer <= 0:
		patrol_timer = randf_range(3.0, 10.0)

		var rand_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		if rand_dir.length() < 0.1:
			rand_dir = Vector2.RIGHT

		move_direction = rand_dir.normalized()


func fight_state(delta):
	if !is_instance_valid(current_target):
		current_state = State.PATROL if ship_team == 1 else State.TRAVEL
		current_target = null
		return

	var to_target = current_target.global_position - global_position
	var distance = to_target.length()
	var dir_to_target = to_target.normalized()

	# Orbit
	var orbit_vector = Vector2(-dir_to_target.y, dir_to_target.x)
	if orbit_direction == 0:
		orbit_direction = 1 if randi() % 2 == 0 else -1
	orbit_vector *= orbit_direction
	
	if state_timer <= 0:
		# Close in if too far
		if distance > stats.attack_range:
			move_direction = dir_to_target
		
		# Get away if too closez
		elif distance < stats.attack_range * 0.8:
			move_direction = -dir_to_target

		# Otherwise orbit
		else:
			move_direction = (dir_to_target + orbit_vector * 0.5).normalized()

	# Shooting
	if distance <= stats.attack_range:
		shoot_at(current_target)

	apply_movement()


## Todo
func flee_state():
	pass


## For Enemy only - Go shoot planet if no other targets seen
func travel_state(delta):
	if has_target():
		current_state = State.FIGHT
		return

	var distance = (global_position - PlayerManager.planet.global_position).length()
	if distance <= stats.attack_range:
		current_target = PlayerManager.get_planet()

	move_direction = (PlayerManager.planet.global_position - global_position).normalized()
	apply_movement()

func shoot_at(target: Node2D):
	var target_is_planet: bool = target is Planet
	
	if !target_is_planet:
		normal_bullet(target)
		return

	if target_is_planet:
		planet_bullet(target)
		return

	if attack_timer > 0 and !target_is_planet:
		return
	
	if planet_attack_timer > 0 and target_is_planet:
		return

func normal_bullet(target: Node2D):
	if attack_timer > 0:
		return

	attack_timer = stats.attack_speed
	var new_bullet: Bullet = stats.bullet_scene.instantiate()
	var damage = stats.bullet_damage
	var speed = stats.bullet_speed
	var bullet_scale = stats.bullet_scale
	bullet_logic(new_bullet, target, damage, speed, bullet_scale)


func planet_bullet(target: Node2D):
	if planet_attack_timer > 0:
		return

	planet_attack_timer = stats.planet_attack_speed
	var new_bullet: PlanetKillerBullet = stats.planet_bullet_scene.instantiate()
	var damage = stats.planet_bullet_damage
	var speed = stats.planet_bullet_speed
	var bullet_scale = stats.planet_bullet_scale
	bullet_logic(new_bullet, target, damage, speed, bullet_scale)
	

func bullet_logic(bullet: Bullet, target: Node2D, damage: float, speed: float, bullet_scale: float):
	bullet.global_position = global_position

	var distance_vector = target.global_position - global_position
	var distance = distance_vector.length()

	var target_velocity = Vector2.ZERO
	if target.has_method("get_velocity"):
		target_velocity = target.get_velocity()
		
	var travel_time = distance / stats.bullet_speed

	var predicted_pos = target.global_position + target_velocity * travel_time
	var direction = (predicted_pos - global_position).normalized()
	bullet.scale = Vector2(bullet_scale, bullet_scale)
	bullet.initialize_bullet(damage, speed, hitbox, direction)

	get_tree().current_scene.add_child(bullet)


func has_target() -> bool:
	return current_target != null
	

func apply_movement():

	velocity = move_direction * stats.movement_speed
	move_and_slide()
