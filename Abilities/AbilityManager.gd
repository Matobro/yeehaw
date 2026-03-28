extends Node

var config: AbilityConfig = preload("res://Abilities/AbilityConfig.tres")
var ability_slot_scene: PackedScene = preload("res://Abilities/AbilitySlot.tscn")

@onready var ability_list: HBoxContainer = $"../PlanetScene/UI/Abilities/VBoxContainer/Panel/AbilityList"


func add_ability(ability_data):
	var new_slot: AbilitySlot = ability_slot_scene.instantiate()
	new_slot.initialize_slot(ability_data)
	ability_list.add_child(new_slot)


func add_ability_by_unlock(unlock: Unlock.Type):
	print("adding ability")
	if config.abilities.has(unlock):
		print("success")
		add_ability(config.abilities[unlock])
