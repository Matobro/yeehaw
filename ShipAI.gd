extends CharacterBody2D

enum State { PATROL, ENGAGE, FIGHT, FLEE }

@export var _stats: ShipStats
@export var hitbox: HitBox
@export var aggrobox: AggroBox

@export var ship_team: int = 1
var stats: ShipStats

var current_state: State = State.PATROL
var state_update_speed: float = 1.0

var current_target: Node2D

var center = Vector2.ZERO

var state_timer: float = 0.0
var patrol_timer: float = 0.0

var move_direction: Vector2 = Vector2.ZERO
var current_angle: float
var attack_timer: float = 0.0
var orbit_direction: int


func _ready():
	stats = _stats.duplicate(true)
	velocity = Vector2.RIGHT * 10.0
	aggrobox.ship_team = ship_team
	hitbox.ship_team = ship_team
	aggrobox.origin = hitbox
	aggrobox.enemy_spotted.connect(on_enemy_spotted)
	var aggro_radius: CircleShape2D = aggrobox.get_node("CollisionShape2D").shape
	aggro_radius.radius = stats.seek_range


func _physics_process(delta):
	if attack_timer > 0:
		attack_timer -= delta

	if current_state != State.FIGHT:
		current_angle = velocity.angle() + deg_to_rad(90)
		rotation = current_angle
	state_timer -= delta

	decide_action(delta)


func decide_action(delta):
	if current_state == null:
		current_state = State.PATROL

	match current_state:
		State.PATROL:
			patrol_state(delta)
		State.ENGAGE:
			engage_state(delta)
		State.FIGHT:
			fight_state(delta)
		State.FLEE:
			flee_state()


func on_enemy_spotted(_enemy_hitbox: Area2D):
	current_target = _enemy_hitbox
	print("Enemy spotted")


func patrol_state(delta):
	update_patrol(delta)
	if has_target():
		current_state = State.ENGAGE
		return

	var to_center = center - global_position
	var distance = to_center.length()

	var desired_direction = move_direction
	var desired_speed = stats.movement_speed

	if distance > stats.patrol_radius:
		var return_strength = clamp((distance - stats.patrol_radius) / stats.patrol_radius, 0, 1)
		desired_direction = desired_direction.lerp(to_center.normalized(), return_strength)

	apply_movement(desired_direction, desired_speed, delta)


func update_patrol(delta):
	patrol_timer -= delta

	if patrol_timer <= 0:
		patrol_timer = randf_range(2.0, 5.0)
		move_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()


func engage_state(delta):
	if !is_instance_valid(current_target):
		return

	var distance = (global_position - current_target.global_position).length()
	if distance > stats.attack_range:
		var dir = current_target.global_position - global_position
		apply_movement(dir, stats.movement_speed, delta)
	else:
		current_state = State.FIGHT
		orbit_direction = sign(randf() - 0.5)
		return


func fight_state(delta):
	if !is_instance_valid(current_target):
		current_state = State.PATROL
		return

	var to_target = current_target.global_position - global_position
	var distance = to_target.length()
	var dir_to_target = to_target.normalized()

	# --- 1. Maintain distance (in/out movement)
	var desired_distance = stats.attack_range * 0.8
	var distance_error = distance - desired_distance

	var radial = dir_to_target * distance_error

	# --- 2. Orbit (sideways movement)
	var tangent = dir_to_target.orthogonal() * orbit_direction

	# --- 3. Combine movement
	var desired_direction = (radial + tangent).normalized()

	apply_movement(desired_direction, stats.movement_speed, delta)

	# --- 4. Aim at target
	var desired_angle = to_target.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, desired_angle, stats.turn_speed * delta)

	# --- 5. Shoot when roughly facing target
	var angle_diff = abs(wrapf(rotation - desired_angle, -PI, PI))

	if angle_diff < deg_to_rad(10):
		shoot()


func flee_state():
	pass


func shoot():
	if attack_timer > 0:
		return

	attack_timer = stats.attack_speed
	var new_bullet: Bullet = stats.bullet_scene.instantiate()
	new_bullet.initialize_bullet(stats.bullet_damage, stats.bullet_speed, hitbox)
	new_bullet.global_position = global_position
	new_bullet.rotation = rotation
	new_bullet.scale = Vector2(stats.bullet_scale, stats.bullet_scale)
	get_tree().current_scene.add_child(new_bullet)


func has_target() -> bool:
	return current_target != null


func apply_movement(desired_direction: Vector2, desired_speed: float, delta: float):
	if desired_direction == Vector2.ZERO:
		return

	# Steering
	velocity = steer_toward(velocity, desired_direction * desired_speed, delta)

	# Acceleration
	var desired_velocity = desired_direction.normalized() * desired_speed
	velocity = velocity.move_toward(desired_velocity, stats.acceleration * delta)

	move_and_slide()


func steer_toward(current: Vector2, target: Vector2, delta: float) -> Vector2:
	if current == Vector2.ZERO:
		return target

	var current_direction = current.normalized()
	var target_direction = target.normalized()

	var angle_difference = current_direction.angle_to(target_direction)
	var max_step = stats.turn_speed * delta

	angle_difference = clamp(angle_difference, -max_step, max_step)

	var new_direction = current_direction.rotated(angle_difference)
	return new_direction * current.length()
