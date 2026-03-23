class_name Bullet
extends Area2D

var lifetime: float = 3.0
var damage: float
var speed: float
var direction: Vector2
var origin: Area2D


func initialize_bullet(_damage, _speed, _origin):
	damage = _damage
	speed = _speed


func _ready():
	direction = Vector2.UP.rotated(rotation)
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, lifetime)
	tween.tween_callback(queue_free)


func _physics_process(delta):
	position += direction * speed * delta


func on_area_entered(entered_area: Area2D):
	if entered_area == origin:
		return
	if entered_area.has_method("take_damage"):
		entered_area.take_damage(damage)
		queue_free()
