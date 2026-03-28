class_name AbilityData
extends Resource

@export_category("Ability")
@export var ability_name: String
@export var ability_icon: Texture2D
@export var ability_script: Script

@export_category("Stats")
@export var cooldown: float

@export_category("Info")
@export_multiline var description: String
