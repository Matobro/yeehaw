extends TextureProgressBar

@export var forcefield: Forcefield
@export var hp_label: Label


func _ready():
	forcefield.shield_changed.connect(update_bar)


func update_bar(current, _max):
	hp_label.text = str("%.1f" % current)
	max_value = _max
	value = current
