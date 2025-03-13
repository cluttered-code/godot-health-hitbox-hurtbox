class_name HealthModifiedActionMatcher extends GdUnitArgumentMatcher

var _action_matcher: HealthActionMatcher
var _modifier_matcher: HealthModifierMatcher


func _init(modified_action: HealthModifiedAction) -> void:
	_action_matcher = HealthActionMatcher.new(modified_action.action)
	_modifier_matcher = HealthModifierMatcher.new(modified_action.modifier)


func is_match(modified_action) -> bool:
	return _action_matcher.is_match(modified_action.action)\
		&& _modifier_matcher.is_match(modified_action.modifier)
