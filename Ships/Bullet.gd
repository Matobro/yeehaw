class_name Bullet
extends Area2D

var lifetime: float = 3.0
var damage: float
var speed: float
var direction: Vector2
var origin: Area2D


func initialize_bullet(_damage, _speed, _origin, _direction):
	damage = _damage
	speed = _speed
	origin = _origin
	direction = _direction


func _ready():
	extra_setup()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, lifetime)
	tween.tween_callback(queue_free)

	area_entered.connect(on_area_entered)


func extra_setup():
	pass


func _physics_process(delta):
	position += direction * speed * delta


func on_area_entered(entered_area: Area2D):
	if !is_instance_valid(entered_area) or (!is_instance_valid(origin) and origin != null): return
	var ship_team = 1
	if origin == null:
		ship_team = 1
	else:
		ship_team = origin.ship_team

	if entered_area == origin or entered_area.ship_team == ship_team:
		return

	if entered_area.has_method("take_damage"):
		entered_area.take_damage(damage)
		queue_free()
