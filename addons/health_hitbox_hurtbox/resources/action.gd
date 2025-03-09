class_name HealthAction extends Resource


@export var affect: Health.Affect = Health.Affect.DAMAGE
@export var type: HealthActionType.Enum = HealthActionType.Enum.KINETIC
@export var amount: int = 1


func _init(affect: Health.Affect, type: HealthActionType.Enum, amount: int) -> void:
	self.affect = affect
	self.type = type
	self.amount = amount


func duplicate(subresources: bool = false) -> HealthAction:
	return HealthAction.new(affect, type, amount)
