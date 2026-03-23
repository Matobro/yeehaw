class_name MoneyUI
extends Label


func update_money(new_money: float):
	text = str("%.1f" % new_money)
