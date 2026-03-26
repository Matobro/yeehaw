class_name PlanetKillerBullet
extends Bullet

var is_claimed: bool = false

func extra_setup():
	lifetime = 10.0
	
func on_area_entered(entered_area: Area2D):
	if !entered_area.is_in_group("Planet"): return

	if entered_area.has_method("take_damage"):
		entered_area.take_damage(damage)
		queue_free()
