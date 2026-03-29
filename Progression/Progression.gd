extends Node

var unlocks: Array[Unlock.Type] = []
var item_counts: Dictionary = {}
var perk_levels: Dictionary = {}

func add_item(item_id: String):
	item_counts[item_id] = item_counts.get(item_id, 0) + 1

func meets_all(requirements: Array[Requirement]) -> bool:
	if requirements.is_empty():
		return true
	for req in requirements:
		if not req.meets():
			return false
	return true

func add_unlock(new_unlock: Unlock.Type):
	if new_unlock in unlocks:
		return

	unlocks.append(new_unlock)
	AbilityManager.add_ability_by_unlock(new_unlock)