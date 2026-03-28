class_name AbilitySlot
extends Button

@export var cooldown_label: Label
@export var tool_tip: PanelContainer
@export var tool_tip_label: RichTextLabel
@export var ability_icon: TextureRect

@export var slot_ability_data: AbilityData
var cooldown_timer: float = 0.0


func initialize_slot(ability_data: AbilityData):
	slot_ability_data = ability_data
	ability_icon.texture = slot_ability_data.ability_icon


func _ready() -> void:
	update_cooldown_label()
	pressed.connect(on_button_click)
	mouse_entered.connect(on_mouse_hover_enter)
	mouse_exited.connect(on_mouse_hover_exit)
	tool_tip_label.text = slot_ability_data.description

func _physics_process(delta):
	if cooldown_timer > 0:
		cooldown_timer = clampf(cooldown_timer - delta, 0.0, cooldown_timer)
		update_cooldown_label()


func execute_ability():
	var ability_instance: Ability = slot_ability_data.ability_script.new()
	add_child(ability_instance)
	ability_instance.on_use()


func update_cooldown_label():
	cooldown_label.text = str("%d" % cooldown_timer)


func on_button_click():
	if cooldown_timer > 0: 
		return
	
	cooldown_timer = slot_ability_data.cooldown
	update_cooldown_label()

	execute_ability()


func on_mouse_hover_enter():
	tool_tip.visible = true


func on_mouse_hover_exit():
	tool_tip.visible = false
