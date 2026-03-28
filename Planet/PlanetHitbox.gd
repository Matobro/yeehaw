extends Area2D

signal took_damage(amount)

func take_damage(amount):
	emit_signal("took_damage", amount)