extends Button

@export var ui: Control


func _ready():
	pressed.connect(on_button_pressed)


func on_button_pressed():
	ui.visible = !ui.visible
