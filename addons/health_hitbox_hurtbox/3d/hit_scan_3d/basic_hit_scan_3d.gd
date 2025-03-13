@tool
class_name BasicHitScan3D extends HitScan3D
## BasicHitScan3D interacts with [HurtBox3D] to affect [Health] components.


## The [Health.Affect] to be performed.
@export var affect: Health.Affect = Health.Affect.DAMAGE:
	set(a):
		affect = a
		if actions.size() > 0:
			actions[0].affect = a
			actions[0].type = _type_from_affect(a)

## The amount of the action.
@export var amount: int = 1:
	set(a):
		amount = a
		if actions.size() > 0:
			actions[0].amount = amount


func _ready() -> void:
	actions.append(HealthAction.new(affect, _type_from_affect(affect), amount))


func _type_from_affect(affect: Health.Affect) -> HealthActionType.Enum:
	return HealthActionType.Enum.KINETIC if affect == Health.Affect.DAMAGE else HealthActionType.Enum.MEDICINE
