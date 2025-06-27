@tool
class_name BasicHitScan3D extends AbstractHitScan3D
## BasicHitScan3D interacts with [AbstractHurtBox3D] to affect [Health] components.


## The [Health.Affect] to be performed.
@export var affect: Health.Affect = Health.Affect.DAMAGE:
	set(a):
		_actions[0].affect = a
		_actions[0].type = _type_from_affect(a)
	get():
		return _actions[0].affect

## The amount of the action.
@export var amount: int = 1:
	set(a):
		_actions[0].amount = a
	get():
		return _actions[0].amount


func _init() -> void:
	_actions.append(HealthAction.new())


func _type_from_affect(affect: Health.Affect) -> HealthActionType.Enum:
	return HealthActionType.Enum.KINETIC if affect == Health.Affect.DAMAGE else HealthActionType.Enum.MEDICINE
