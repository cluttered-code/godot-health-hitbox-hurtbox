@tool
class_name HurtBox2D extends Area2D
## [HurtBox2D] enables collision detection by [HitBox2D] or [HitScan2D] and applies affects to [Health].


## The [Health] component to affect.
@export var health: Health = null:
	set(new_health):
		health = new_health
		if Engine.is_editor_hint():
			update_configuration_warnings()


## [Modifer] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = {}


func apply_all_actions(actions: Array[HealthAction]) -> void:
	if not health:
		push_error("%s is missing a 'Health' component" % self)
		return
	
	var modified_actions: Array[HealthModifiedAction]
	modified_actions.assign(
		actions.filter(func(action: HealthAction) -> bool: return action != null)
			.map(_map_modified_action)
	)
	
	health.apply_all_modified_actions(modified_actions)


func _map_modified_action(action: HealthAction) -> HealthModifiedAction:
	var modifier := modifiers.get(action.type, HealthModifier.new())
	var modified_action := HealthModifiedAction.new(action, modifier.clone())
	return modified_action


# Warn users if values haven't been configured.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if health is not Health:
		warnings.append("This node requires a 'Health' component")
	
	return warnings
