@tool
class_name HurtBox3D extends AbstractHurtBox3D
## [HurtBox3D] enables collision detection by [AbstractHitBox3D] or [AbstractHitScan3D] and applies affects to [Health].

## [HealthModifier] applied to [HealthActionType.Enum].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = _modifiers
