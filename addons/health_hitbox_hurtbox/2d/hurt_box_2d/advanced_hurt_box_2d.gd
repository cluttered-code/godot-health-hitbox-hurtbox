@tool
class_name AdvancedHurtBox2D extends HurtBox2D
## [AdvancedHurtBox2D] enables collision detection by [HitBox2D] or [HitScan2D] and applies affects to [Health].

## [HealthModifier] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = _modifiers
