class_name OrbitLogic
extends Node2D

var center: Vector2 = Vector2.ZERO
var radius: float = 100.0
var angle: float = 0.0

var orbiting_speed: float = 0.1
var parent: Node2D


func _init(_parent, _center, _radius, _speed):
	parent = _parent
	center = _center
	radius = _radius
	orbiting_speed = _speed
	angle = randf_range(0, 360)


func _process(delta):
	angle += orbiting_speed * delta
	var offset = Vector2(cos(angle), sin(angle)) * radius
	parent.global_position = center + offset
