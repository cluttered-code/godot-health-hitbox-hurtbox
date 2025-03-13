class_name HealthActionMatcher extends GdUnitArgumentMatcher

var _action: HealthAction


func _init(action: HealthAction) -> void:
	_action = action


func is_match(action) -> bool:
	return action is HealthAction\
		&& _action.affect == action.affect\
		&& _action.type == action.type\
		&& _action.amount == action.amount
