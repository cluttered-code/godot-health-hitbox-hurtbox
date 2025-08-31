@tool
class_name AdvancedHurtBox3D extends HurtBox3D
## [AdvancedHurtBox3D] enables collision detection by [HitBox3D] or [HitScan3D] and applies affects to [Health].

## [HealthModifier] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = _modifiers
