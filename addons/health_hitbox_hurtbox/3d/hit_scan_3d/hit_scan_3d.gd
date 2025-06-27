@tool
class_name HitScan3D extends AbstractHitScan3D
## [HitScan3D] interacts with [HurtBox3D] to affect [Health] components.

## [Modifer] applied to [HealthActionType.Enum].
@export var actions: Array[HealthAction] = _actions
