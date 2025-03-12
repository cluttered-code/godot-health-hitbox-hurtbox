@tool
class_name BasicHurtBox2D extends Area2D
## BasicHurtBox2D enables collision detection by [BasicHitBox2D] or [BasicHitScan2D] and applies affects to [Health].

## [Modifer] applied to [HealthActionType.Enum].
var _modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = {
	HealthActionType.Enum.MEDICINE: HealthModifier.new(),
	HealthActionType.Enum.KINETIC: HealthModifier.new()
}

## The [Health] component to affect.
@export var health: Health = null:
	set(new_health):
		health = new_health
		if Engine.is_editor_hint():
			update_configuration_warnings()

## The multiplier to apply to all damage actions.
@export var damage_multiplier: float = 1.0:
	get():
		return _modifiers[HealthActionType.Enum.KINETIC].multiplier
	set(mult):
		_modifiers[HealthActionType.Enum.KINETIC].multiplier = mult

## The multiplier to apply to all heal actions.
@export var heal_multiplier: float = 1.0:
	get():
		return _modifiers[HealthActionType.Enum.MEDICINE].multiplier
	set(mult):
		_modifiers[HealthActionType.Enum.MEDICINE].multiplier = mult

@export_group("Advanced")

## Applies healing to [Health] when [color=orange]damage()[/color] is called.
@export var heal_on_damage: bool = false:
	get():
		return _modifiers[HealthActionType.Enum.KINETIC].convert_affect == Health.Affect.HEAL
	set(b):
		_modifiers[HealthActionType.Enum.KINETIC].convert_affect = Health.Affect.HEAL if b else Health.Affect.DAMAGE

## Applies damage to [Health] when [color=orange]heal()[/color] is called.
@export var damage_on_heal: bool = false:
	get():
		return _modifiers[HealthActionType.Enum.MEDICINE].convert_affect == Health.Affect.DAMAGE
	set(b):
		_modifiers[HealthActionType.Enum.MEDICINE].convert_affect = Health.Affect.DAMAGE if b else Health.Affect.HEAL


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
	var modifier := _modifiers.get(action.type, HealthModifier.new()).duplicate() as HealthModifier
	var modified_action := HealthModifiedAction.new(action, modifier)
	return modified_action


# Warn users if values haven't been configured.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if health is not Health:
		warnings.append("This node requires a 'Health' component")
	
	return warnings
