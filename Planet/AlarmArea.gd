class_name AlarmArea
extends Area2D

@export var alarm_area: Area2D
@export var ally_area: Area2D

var enemies_in_area: Array[Ship]
var allies_in_area: Array[Ship]

var alarm_time: float = 1.0
var alarm_timer: float = 0.0

func _ready() -> void:
	alarm_area.area_entered.connect(on_alarm_area_entered)
	alarm_area.area_exited.connect(on_alarm_area_exited)
	ally_area.area_entered.connect(on_ally_area_entered)
	ally_area.area_exited.connect(on_ally_area_exited)


func _physics_process(delta):
	alarm_timer -= delta
	if alarm_timer <= 0:
		alarm_timer = alarm_time
		sound_alarm()


func sound_alarm():
	for i in range(allies_in_area.size()):
		if !is_instance_valid(allies_in_area[i]):
			allies_in_area.remove_at(i)
			continue

		var ally: Ship = allies_in_area[i]

		if enemies_in_area.size() <= 0: continue

		var rng_enemy_index: int = randi_range(0, enemies_in_area.size() - 1)
		
		if !is_instance_valid(enemies_in_area[rng_enemy_index]):
			enemies_in_area.remove_at(rng_enemy_index)
			continue

		ally.on_alarm(enemies_in_area[rng_enemy_index])
	

func on_alarm_area_entered(entered_area: Area2D):
	if !entered_area.is_in_group("Ship"):
		return
		
	if entered_area.ship_team != 1:
		enemies_in_area.append(entered_area.origin)


func on_alarm_area_exited(exited_area: Area2D):
	if exited_area.ship_team != 1:
		if exited_area.origin in enemies_in_area:
			enemies_in_area.erase(exited_area.origin)


func on_ally_area_entered(entered_area: Area2D):
	if !entered_area.is_in_group("Ship"):
		return
		
	if entered_area.ship_team == 1:
		allies_in_area.append(entered_area.origin)


func on_ally_area_exited(exited_area: Area2D):
	if exited_area.ship_team == 1:
		if exited_area.origin in allies_in_area:
			allies_in_area.erase(exited_area.origin)


func get_random_enemy_in_area() -> Ship:
	var valid_enemies = enemies_in_area.filter(func(ship):
		return is_instance_valid(ship) and not ship.dead
	)
	
	if valid_enemies.is_empty():
		return null
	
	return valid_enemies.pick_random()
