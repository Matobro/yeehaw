class_name AggroBox
extends Area2D

signal enemy_spotted(enemy: Node2D)
var origin: Node2D
var ship_team = 0


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(entered_area: Area2D):
	if entered_area == origin or !entered_area.is_in_group("Ship"):
		return
	if entered_area.ship_team != ship_team:
		emit_signal("enemy_spotted", entered_area.origin)
