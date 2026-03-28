extends Button

@export var all_tabs: Array[Control]
@export var tab_opened: Control

var tab_open: bool


func _ready():
	pressed.connect(on_button_pressed)


func on_button_pressed():
	tab_open = tab_opened.visible
	for tab in all_tabs:
		tab.visible = false

	tab_opened.visible = !tab_open
