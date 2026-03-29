extends Node

@onready var player: Player = $"../PlanetScene/Player"
@onready var planet: Node2D = $"../PlanetScene/Map/Planet"


func get_player() -> Player:
    return player

func get_planet() -> Planet:
    return planet

func end_screen():
    get_tree().paused = true
    get_tree().call_deferred("change_scene_to_file", "res://LevelScenes/YouLost.tscn")