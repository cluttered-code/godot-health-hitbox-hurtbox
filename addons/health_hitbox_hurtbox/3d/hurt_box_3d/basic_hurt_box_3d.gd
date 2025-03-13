@tool
class_name BasicHurtBox3D extends HurtBox3D
## [BasicHurtBox3D] enables collision detection by [HitBox3D] or [HitScan3D] and applies affects to [Health].

## The multiplier to apply to all damage actions.
@export var damage_multiplier: float = 1.0:
	set(mult):
		damage_multiplier = mult
		if modifiers.has(HealthActionType.Enum.KINETIC):
			modifiers[HealthActionType.Enum.KINETIC].multiplier = mult

## The multiplier to apply to all heal actions.
@export var heal_multiplier: float = 1.0:
	set(mult):
		heal_multiplier = mult
		if modifiers.has(HealthActionType.Enum.MEDICINE):
			modifiers[HealthActionType.Enum.MEDICINE].multiplier = mult

@export_group("Advanced")

## Applies healing to [Health] when [color=orange]damage()[/color] is called.
@export var heal_on_damage: bool = false:
	set(enable):
		heal_on_damage = enable
		if modifiers.has(HealthActionType.Enum.KINETIC):
			modifiers[HealthActionType.Enum.KINETIC].convert_affect = _affect_heal_on_damage(enable)


## Applies damage to [Health] when [color=orange]heal()[/color] is called.
@export var damage_on_heal: bool = false:
	set(enable):
		damage_on_heal = enable
		if modifiers.has(HealthActionType.Enum.MEDICINE):
			modifiers[HealthActionType.Enum.MEDICINE].convert_affect = _affect_damage_on_heal(enable)



func _ready() -> void:
	modifiers[HealthActionType.Enum.KINETIC] = HealthModifier.new(0, damage_multiplier, _affect_heal_on_damage(heal_on_damage))
	modifiers[HealthActionType.Enum.MEDICINE] = HealthModifier.new(0, heal_multiplier, _affect_damage_on_heal(damage_on_heal))


func _affect_heal_on_damage(enabled: bool) -> Health.Affect:
	return Health.Affect.HEAL if enabled else Health.Affect.NONE


func _affect_damage_on_heal(enabled: bool) -> Health.Affect:
	return Health.Affect.DAMAGE if enabled else Health.Affect.NONE
