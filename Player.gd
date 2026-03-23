class_name Player
extends Node

@export_category("Dependencies")
@export var money_ui: MoneyUI
@export var energy: float = 2.0


func _ready():
	update_money()


func add_energy(amount: float):
	energy += amount
	update_money()


func update_money():
	money_ui.update_money(energy)
