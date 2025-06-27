@tool
class_name HitBox3D extends AbstractHitBox3D
## [HitBox3D] is associated with an entity that can collide with an [AbstractHurtBox3D].

## [HealthAction] components associated with this [HitBox3D].
@export var actions: Array[HealthAction] = _actions
