class_name HealthModifiedAction extends Resource

var action: HealthAction
var modifier: HealthModifier

## passthrough returns the modifier.convert_affect or action.affect
var affect: Health.Affect:
	get():
		return modifier.convert_affect if modifier.convert_affect != Health.Affect.NONE else action.affect

## passthrough returns the modifier.convert_type or action.type
var type: HealthActionType.Enum:
	get():
		return modifier.convert_type if modifier.convert_type != HealthActionType.Enum.NONE else action.type

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



## clone because duplicate() doesn't work with _init() parameters
func clone() -> HealthModifiedAction:
	return HealthModifiedAction.new(action.clone(), modifier.clone())


func _to_string() -> String:
	return "HealthModifiedAction<%s %s>" % [action, modifier]
