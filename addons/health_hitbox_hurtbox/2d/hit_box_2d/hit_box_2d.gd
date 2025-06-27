@tool
class_name HitBox2D extends AbstractHitBox2D
## [HitBox2D] is associated with an entity that can collide with an [AbstractHurtBox2D].

## [HealthAction] components associated with this [HitBox2D].
@export var actions: Array[HealthAction] = _actions
