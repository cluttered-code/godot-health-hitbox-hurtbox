class_name HealthModifier extends Resource

@export var incrementer: int = 0
@export var multiplier: float = 1.0

@export var convert_affect: Health.Affect = Health.Affect.NONE
@export var convert_type: HealthActionType.Enum = HealthActionType.Enum.NONE


func _init(
	incrementer: int = 0,
	multiplier: float = 1.0,
	convert_affect: Health.Affect = Health.Affect.NONE,
	convert_type: HealthActionType.Enum = HealthActionType.Enum.NONE
) -> void:
	self.incrementer = incrementer
	self.multiplier = multiplier
	self.convert_affect = convert_affect
	self.convert_type = convert_type



## clone because duplicate() doesn't work with _init() parameters
func clone() -> HealthModifier:
	return HealthModifier.new(incrementer, multiplier, convert_affect, convert_type)


func _to_string() -> String:
	return "HealthModifier<incrementer=%d multiplier=%0.4f convert_affect=%s conver_type=%s>"\
		% [incrementer, multiplier, Health.Affect.find_key(convert_affect), HealthActionType.Enum.find_key(convert_type)]
