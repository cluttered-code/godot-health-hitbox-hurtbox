@icon("res://addons/health_hitbox_hurtbox/2d/hurt_box_2d/hurt_box_2d.svg")
class_name AbstractHurtBox2D extends Area2D
## [AbstractHurtBox2D] enables collision detection by [AbstractHitBox2D] or [AbstractHitScan2D] and applies affects to [Health].

var _modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = {}

## The [Health] component to affect.
@export var health: Health = null:
	set(new_health):
		health = new_health
		if Engine.is_editor_hint():
			update_configuration_warnings()


## Applies all the specified [HealthAction] to this [AbstractHurtBox2D].
func apply_all_actions(actions: Array[HealthAction]) -> void:
	if not health:
		push_error("%s is missing a 'Health' component" % self)
		return
	
	var modified_actions: Array[HealthModifiedAction]
	modified_actions.assign(
		actions
			.filter(_filter_null_actions)
			.map(_map_modified_action)
	)
	
	health.apply_all_modified_actions(modified_actions)


func _filter_null_actions(action: HealthAction) -> bool:
	return action != null


func _map_modified_action(action: HealthAction) -> HealthModifiedAction:
	var modifier := _modifiers.get(action.type, HealthModifier.new())
	var modified_action := HealthModifiedAction.new(action, modifier.clone())
	return modified_action


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if health is not Health:
		warnings.append("This node requires a 'Health' component")
	
	return warnings
