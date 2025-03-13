class_name HealthAction extends Resource


@export var affect: Health.Affect = Health.Affect.DAMAGE
@export var type: HealthActionType.Enum = HealthActionType.Enum.KINETIC
@export var amount: int = 1


func _init(affect: Health.Affect = Health.Affect.DAMAGE, type: HealthActionType.Enum = HealthActionType.Enum.KINETIC, amount: int = 1) -> void:
	self.affect = affect
	self.type = type
	self.amount = amount


## clone because duplicate() doesn't work with _init() parameters
func clone() -> HealthAction:
	return HealthAction.new(affect, type, amount)


func _to_string() -> String:
	return "HealthAction<affect=%s type=%s amount=%d>" % [Health.Affect.find_key(affect), HealthActionType.Enum.find_key(type), amount]
