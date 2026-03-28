class_name Player
extends Node

@export_category("Dependencies")
@export var money_ui: MoneyUI
@export var level_ui: LevelUI
@export var level_bar: LevelBar
@export var energy: float = 2.0

var level: int = 0
var experience: int = 0
var required_experience = 100
var experience_scaling: float = 1.2

var available_perk_points: int = 0
var total_perk_points: int = 0

func _ready():
	add_experience(100)
	update_money()
	update_level()
	update_perk_points()


func add_energy(amount: float):
	energy += amount
	update_money()


func add_experience(amount: int):
	var gained_experience = amount
	experience += gained_experience
	if experience >= required_experience:
		experience = 0
		gained_experience -= required_experience
		experience += gained_experience
		gain_level()

	level_bar.update_bar(experience, required_experience)

func gain_level():
	level += 1
	available_perk_points += 1
	total_perk_points += 1
	required_experience = round(required_experience * experience_scaling)
	update_level()
	update_perk_points()


func update_level():
	level_ui.update_level(level)


func update_perk_points():
	level_ui.update_perks(available_perk_points)


func update_money():
	money_ui.update_money(energy)
