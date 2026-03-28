extends Node


var unlocks: Array[Unlock.Type] = []


func new_unlock(unlock: Unlock.Type):
	if unlock in unlocks:
		return
	
	unlocks.append(unlock)
	
	match unlock:
		Unlock.Type.SATELLITE_OVERCHARGE:
			AbilityManager.add_ability_by_unlock(unlock)
		_:
			pass
