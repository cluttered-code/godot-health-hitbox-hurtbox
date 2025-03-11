class_name HealthModifierMatcher extends GdUnitArgumentMatcher

var _modifier: HealthModifier


func _init(modifier: HealthModifier) -> void:
	_modifier = modifier


func is_match(modifier) -> bool:
	return modifier is HealthModifier\
		&& _modifier.incrementer == modifier.incrementer\
		&& _modifier.multiplier == modifier.multiplier\
		&& _modifier.convert_affect == modifier.convert_affect\
		&& _modifier.convert_type == modifier.convert_type
