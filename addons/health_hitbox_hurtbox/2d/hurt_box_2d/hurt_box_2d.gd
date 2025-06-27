@tool
class_name HurtBox2D extends AbstractHurtBox2D
## [HurtBox2D] enables collision detection by [AbstractHitBox2D] or [AbstractHitScan2D] and applies affects to [Health].

## [HealthModifier] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = _modifiers
