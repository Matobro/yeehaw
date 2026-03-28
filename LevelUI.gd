class_name LevelUI
extends Control

@export var level_label: Label
@export var perk_label: Label


func update_level(new_level: int):
	level_label.text = str("%d" % new_level)


func update_perks(new_perks: int):
	perk_label.text = str("%d" % new_perks)