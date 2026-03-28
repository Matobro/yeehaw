class_name Planet
extends Node2D

@export var alarm_area: AlarmArea
@export var ally_area: Area2D
@export var bullet_area: BulletArea


func _ready() -> void:
	pass 


func get_alarm_area() -> AlarmArea:
	return alarm_area


func get_ally_area() -> Area2D:
	return ally_area


func get_bullet_area() -> BulletArea:
	return bullet_area

