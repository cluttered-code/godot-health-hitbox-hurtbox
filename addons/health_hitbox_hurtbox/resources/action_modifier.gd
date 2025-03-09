class_name HealthActionModifier extends Resource

var action: HealthAction
var modifier: HealthModifier

## passthrough returns the modifier.convert_affect or action.affect
var affect: Health.Affect:
	get():
		return modifier.convert_affect if modifier.convert_affect else action.affect

## passthought returns the modifier.conver_type or action.type
var type: HealthActionType.Enum:
	get():
		return modifier.convert_type if modifier.convert_type else action.type

## passthrough returns action.amount
var amount: int:
	get():
		return action.amount

## passthrough returns modifier.incrementer
var incrementer: int:
	get():
		return modifier.incrementer

## passthrough returns modifier.multiplier
var multiplier: float:
	get():
		return modifier.multiplier


func _init(action: HealthAction, modifier: HealthModifier) -> void:
	self.action = action
	self.modifier = modifier


func duplicate(subresources: bool = false) -> HealthActionModifier:
	return HealthActionModifier.new(action.duplicate(subresources), modifier.duplicate(subresources))
