class_name PurchaseSatellite
extends Button

signal satellite_purchased


func _ready():
	pressed.connect(on_button_pressed)


func on_button_pressed():
	emit_signal("satellite_purchased")
