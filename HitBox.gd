class_name HitBox
extends Area2D

signal took_damage(amount: float)
var ship_team = 0
var origin: Node2D

func take_damage(amount: float):
    emit_signal("took_damage", amount)