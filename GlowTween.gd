extends Sprite2D

@export var start_alpha: float = 1.0
@export var end_alpha: float = 0.0
@export var duration: float = 1.0


func _ready():
	var tween = create_tween().set_loops()

	tween.tween_property(self, "modulate:a", start_alpha, duration)
	tween.tween_property(self, "modulate:a", end_alpha, duration)
