@tool
class_name HitScan2D extends AbstractHitScan2D
## [HitScan2D] interacts with [HurtBox2D] to affect [Health] components.

## [Modifer] applied to [HealthActionType.Enum].
@export var actions: Array[HealthAction] = _actions
