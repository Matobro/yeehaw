class_name BulletArea
extends Area2D

var bullets_in_area: Array[PlanetKillerBullet]

func _ready() -> void:
	area_entered.connect(on_area_entered)


func _process(delta: float) -> void:
	pass


func on_area_entered(entered_area: Area2D):
	if entered_area is PlanetKillerBullet:
		var bullet: PlanetKillerBullet = entered_area
		bullets_in_area.append(bullet)
		bullet.tree_exited.connect(on_bullet_removed.bind(bullet))

func on_bullet_removed(bullet: PlanetKillerBullet):
	bullets_in_area.erase(bullet)


func get_random_bullet() -> PlanetKillerBullet:
	if bullets_in_area.is_empty():
		return null

	var available = bullets_in_area.filter(func(b): 
		return is_instance_valid(b) and not b.is_claimed
	)

	if available.is_empty():
		return null

	var bullet: PlanetKillerBullet = available.pick_random()
	bullet.is_claimed = true
	return bullet
