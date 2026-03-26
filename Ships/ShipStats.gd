class_name ShipStats

extends Resource

@export_category("Combat")
@export var seek_range: float
@export var attack_range: float
@export var attack_speed: float

@export_category("Planet Combat")
@export var planet_bullet_scene: PackedScene
@export var planet_bullet_damage: float
@export var planet_bullet_speed: float
@export var planet_attack_speed: float
@export var planet_bullet_scale: float

@export_category("Bullet")
@export var bullet_scene: PackedScene
@export var bullet_damage: float
@export var bullet_speed: float
@export var bullet_scale: float

@export_category("Movement")
@export var movement_speed: float
@export var turn_speed: float
@export var acceleration = 200.0
@export var patrol_radius: float

@export_category("Stats")
@export var max_health: float

@export_category("Loot")
@export var energy_dropped: float

var current_health: float
