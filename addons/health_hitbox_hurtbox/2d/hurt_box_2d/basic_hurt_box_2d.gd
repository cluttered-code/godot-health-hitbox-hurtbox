@tool
class_name BasicHurtBox2D extends AbstractHurtBox2D
## [BasicHurtBox2D] enables collision detection by [AbstractHitBox2D] or [AbstractHitScan2D] and applies affects to [Health].


@export_group("Damage")
## The incrementer to apply to all damage actions.
@export var damage_incrementer: int = 0:
	set(inc):
		_modifiers[HealthActionType.Enum.KINETIC].incrementer = inc
	get():
		return _modifiers[HealthActionType.Enum.KINETIC].incrementer
## The multiplier to apply to all damage actions.
@export var damage_multiplier: float = 1.0:
	set(mult):
		_modifiers[HealthActionType.Enum.KINETIC].multiplier = mult
	get():
		return _modifiers[HealthActionType.Enum.KINETIC].multiplier
## Applies healing to [Health] when [color=orange]damage()[/color] is called.
@export var heal_on_damage: bool = false:
	set(toggle):
		_modifiers[HealthActionType.Enum.KINETIC].convert_affect = Health.Affect.HEAL if toggle else Health.Affect.NONE
	get():
		return _modifiers[HealthActionType.Enum.KINETIC].convert_affect == Health.Affect.HEAL


@export_group("Heal")
## The incrementer to apply to all heal actions.
@export var heal_incrementer: int = 0:
	set(inc):
		_modifiers[HealthActionType.Enum.MEDICINE].incrementer = inc
	get():
		return _modifiers[HealthActionType.Enum.MEDICINE].incrementer
## The multiplier to apply to all heal actions.
@export var heal_multiplier: float = 1.0:
	set(mult):
		_modifiers[HealthActionType.Enum.MEDICINE].multiplier = mult
	get():
		return _modifiers[HealthActionType.Enum.MEDICINE].multiplier
## Applies damage to [Health] when [color=orange]heal()[/color] is called.
@export var damage_on_heal: bool = false:
	set(toggle):
		_modifiers[HealthActionType.Enum.MEDICINE].convert_affect = Health.Affect.DAMAGE if toggle else Health.Affect.NONE
	get():
		return _modifiers[HealthActionType.Enum.MEDICINE].convert_affect == Health.Affect.DAMAGE


func _init() -> void:
	_modifiers[HealthActionType.Enum.KINETIC] = HealthModifier.new()
	_modifiers[HealthActionType.Enum.MEDICINE] = HealthModifier.new()
