class_name Forcefield
extends Node2D

signal shield_changed(current, max)
@export var forcefield_node: Node2D
@export var hitbox: Area2D

var shield_current: float = 10.0

var regeneration_timer: float = 0.0
var regeneration_tick_timer: float = 0.0

var lost: bool = false

func _ready():
	shield_current = Economy.get_max_shield()
	hitbox.took_damage.connect(damage_shield)
	on_shield_value_changed()


func _physics_process(delta):
	regenerate_shield(delta)


func regenerate_shield(delta):
	var shield_max = Economy.get_max_shield()
	if shield_current >= shield_max:
		return

	regeneration_timer -= delta
	regeneration_tick_timer -= delta

	if regeneration_timer > 0.0:
		return

	if regeneration_tick_timer > 0:
		return

	regeneration_tick_timer = Economy.get_shield_regeneration_speed()
	shield_current = clamp(
		shield_current + Economy.get_shield_regeneration_amount(), 0.0, shield_max
	)
	on_shield_value_changed()


func damage_shield(amount):
	var shield_max = Economy.get_max_shield()
	shield_current = clamp(shield_current - amount, 0, shield_max)
	regeneration_timer = Economy.get_shield_regeneration_delay()
	on_shield_value_changed()


func on_shield_value_changed():
	if shield_current <= 0 and !lost:
		lost = true
		PlayerManager.end_screen()
		return
	var shield_max = Economy.get_max_shield()
	emit_signal("shield_changed", shield_current, shield_max)
	var shield_percentage = shield_current / shield_max
	forcefield_node.modulate.a = shield_percentage
