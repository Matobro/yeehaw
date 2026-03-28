class_name FloatingText
extends Label

var velocity = Vector2(0, -50)
var lifetime = 1.0


func _init(_text):
	text = _text
	z_index = 100


func _process(delta):
	position += velocity * delta
	lifetime -= delta

	modulate = Color.GREEN
	modulate.a = lifetime

	if lifetime <= 0:
		queue_free()
