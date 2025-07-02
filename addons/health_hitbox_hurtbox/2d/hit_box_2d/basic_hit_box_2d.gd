@tool
class_name BasicHitBox2D extends AbstractHitBox2D
## [BasicHitBox2D] is associated with an entity that can collide with an [AbstractHurtBox2D].


## The [Health.Affect] to be performed.
@export var affect: Health.Affect = Health.Affect.DAMAGE:
	set(a):
		_actions[0].affect = a
		_actions[0].type = _type_from_affect(a)
	get():
		return _actions[0].affect

## The amount of the [HealthAction].
@export var amount: int = 1:
	set(a):
		_actions[0].amount = a
	get():
		return _actions[0].amount


func _type_from_affect(affect: Health.Affect) -> HealthActionType.Enum:
	return HealthActionType.Enum.KINETIC if affect == Health.Affect.DAMAGE else HealthActionType.Enum.MEDICINE


func _init() -> void:
	_actions.append(HealthAction.new())
