class_name Requirement
extends Resource

enum Type {
	UNLOCK,
	ITEM_COUNT,
	PERK_LEVEL,
	PLAYER_LEVEL
}

@export var type: Type

@export var unlock_type: Unlock.Type
@export var item_id: String
@export var perk_id: String

@export var required_amount: int = 1


func meets() -> bool:
	match type:
		Type.UNLOCK:
			return unlock_type in Progression.unlocks

		Type.ITEM_COUNT:
			return Progression.item_counts.get(item_id, 0) >= required_amount

		Type.PERK_LEVEL:
			return Progression.perk_levels.get(perk_id, 0) >= required_amount

		Type.PLAYER_LEVEL:
			return PlayerManager.player.level >= required_amount

	return false

	
static func item(_item_id: String, amount: int = 1) -> Requirement:
	var r = Requirement.new()
	r.type = Type.ITEM_COUNT
	r.item_id = _item_id
	r.required_amount = amount
	return r


static func perk(_perk_id: String, level: int) -> Requirement:
	var r = Requirement.new()
	r.type = Type.PERK_LEVEL
	r.perk_id = _perk_id
	r.required_amount = level
	return r