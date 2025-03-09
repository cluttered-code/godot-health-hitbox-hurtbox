@tool
class_name HurtBox2D extends Area2D
## HurtBox2D enables collision detection by [HitBox2D] or [HitScan2D] and applies affects to [Health].

## The [Health] component to affect.
@export var health: Health = null:
	set(new_health):
		health = new_health
		if Engine.is_editor_hint():
			update_configuration_warnings()

## [HealthModifier] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = {}


## Will apply [Array] of [HealthActionMultipler] to [Health].
func apply(actions: Array[HealthAction]) -> void:
	var ams = actions\
		.filter(func(action: HealthAction): return action)\
		.map(_compose_action_modifier)
	
	var action_modifiers: Array[HealthActionModifier]
	action_modifiers.assign(ams)
	health.apply_all(action_modifiers)


func _compose_action_modifier(action: HealthAction) -> HealthActionModifier:
	var modifier := _get_modifier(action.type)
	return HealthActionModifier.new(action, modifier)


func _get_modifier(type: HealthActionType.Enum) -> HealthModifier:
	return modifiers.get(type, HealthModifier.new())

# Warn users if values haven't been configured.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if health is not Health:
		warnings.append("This node requires a 'Health' component")
	
	return warnings
