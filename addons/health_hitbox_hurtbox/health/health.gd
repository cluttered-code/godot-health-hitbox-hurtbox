class_name Health extends Node
## Health is used to track an entity's health, death, and revival.


## Affect an action will have on [Health].
enum Affect { NONE, DAMAGE, HEAL }

## Emitted after damage is applied.
signal damaged(entity: Node, type: HealthActionType.Enum, amount: int, incrementer: int, multiplier: float, applied: int)
## Emitted after damage is applied when death has occured.
signal died(entity: Node)

## Emitted after healing is applied.
signal healed(entity: Node, type: HealthActionType.Enum, amount: int, incrementer: int, multiplier: float, applied: int)
## Emitted after healing is applied when dead.
signal revived(entity: Node)

## Emitted after damage or healing is applied.
signal action_applied(action: HealthModifiedAction, applied: int)


## Emitted when damaged and entity had full health.
signal first_hit(entity: Node)
## Emitted when trying to damage an entity that is not damageable.
signal not_damageable(entity: Node)
## Emitted when damaging and current health is already zero.
signal already_dead(entity: Node)
## Emitted when trying to apply enough damage to an enemy to kill them and they cannot be.
signal not_killable(entity: Node)


## Emitted when trying to heal and entity is not healable.
signal not_healable(entity: Node)
## Emitted when enity is healed and health is now full.
signal full(entity: Node)
## Emitted when healing and current health is already full.
signal already_full(entity: Node)
## Emitted when trying to heal a dead entity that is not revivable
signal not_revivable(entity: Node)

const DEFAULT_MAX = 100

## The current amount of health.[br]
## Value is clamped [0, max].
@export var current: int = DEFAULT_MAX:
	set(curr):
		current = clampi(curr, 0, max)

## The maximum amount of health.[br]
## Will not allow values < 1.
## Will reduce current if greater than updated max.[br]
@export var max: int = DEFAULT_MAX:
	set(new_max):
		var old_max = max
		max = maxi(new_max, 1)
		# after max is set or current will clamp wrong
		if Engine.is_editor_hint() and current == old_max:
			# keep full health in editor if it was before
			current = max
		else:
			# reduce current in game so it is not greater than max
			current = mini(current, max)

@export_group("Conditions")
## Enable if entity is capable of taking damage.
@export var damageable: bool = true
## Enable if entity is capable of being healed.
@export var healable: bool = true
## Enable if entity is able to be killed.
@export var killable: bool = true
## Enable if entity is able to be revived from death.
@export var revivable: bool = true


@export_group("Advanced")
## Additional [Modifer] applied to [Affect.Type].
@export var modifiers: Dictionary[HealthActionType.Enum, HealthModifier] = {}
## The entity this component is tracking health for,
## sent in signals for association.[br][br]
## Defaults to [color=orange]owner[/color].
@export var entity: Node:
	get():
		return entity if entity else owner


## Returns [color=orange]true[/color] when not alive.
func is_dead() -> bool:
	return current == 0 and killable


## Returns [color=orange]true[/color] when current health is greater than 0.
func is_alive() -> bool:
	return not is_dead()


## Return [color=orange]true[/color] when current health is max.
func is_full() -> bool:
	return current == max


## Returns the percent of current to maximum health.
func percent() -> float:
	return clampf(float(current) / float(max), 0.0, 1.0)


## Apply enough damage to kill.
func kill() -> void:
	damage(current)


## Apply enough healing to fill.
func fill() -> void:
	heal(max - current)


## Apply all the [HealthAction] objects in the arary.
func apply_all_actions(actions: Array[HealthAction]) -> void:
	actions.all(apply_action)


## Apply the specified [HealthAction].
func apply_action(action: HealthAction) -> void:
	var modified_action := HealthModifiedAction.new(action, HealthModifier.new())
	apply_modified_action(modified_action)


## Apply all the [HealthModifiedAction] objects in the arary.
func apply_all_modified_actions(actions: Array[HealthModifiedAction]) -> void:
	actions.all(apply_modified_action)


## Apply the specified [HealthModifiedAction].
func apply_modified_action(action: HealthModifiedAction) -> void:
	if not action:
		return
	
	var modifier := _get_modifier(action.type)

	var affect: Affect = modifier.convert_affect if modifier.convert_affect else action.affect
	var type: HealthActionType.Enum = modifier.convert_type if modifier.convert_type else action.type

	var amount := action.amount
	var incrementer := action.incrementer + modifier.incrementer
	var multiplier := action.multiplier * modifier.multiplier

	match affect:
		Affect.DAMAGE:
			_damage(amount, incrementer, multiplier, type)
		Affect.HEAL:
			_heal(amount, incrementer, multiplier, type)
		_:
			print_debug("%s affect unimplemented" % affect)


## Apply the specified amount of damage if damageable and not dead.
func damage(amount: int, incrementer: int = 0, multiplier: float = 1.0, type: HealthActionType.Enum = HealthActionType.Enum.NONE) -> void:
	var modifier := _get_modifier(type)

	var affect: Affect = modifier.convert_affect if modifier.convert_affect else Affect.DAMAGE
	if modifier.convert_type:
		type = modifier.convert_type

	incrementer += modifier.incrementer
	multiplier *= modifier.multiplier

	if affect == Affect.HEAL:
		_heal(amount, incrementer, multiplier, type)
		return
	
	_damage(amount, incrementer, multiplier, type)


## apply the specified amount of healing if healable, not full, or dead and revivable.
func heal(amount: int, incrementer: int = 0, multiplier: float = 1.0, type: HealthActionType.Enum = HealthActionType.Enum.NONE) -> void:
	var modifier := _get_modifier(type)

	var affect: Affect = modifier.convert_affect if modifier.convert_affect else Affect.HEAL
	if modifier.convert_type:
		type = modifier.convert_type

	incrementer += modifier.incrementer
	multiplier *= modifier.multiplier

	if affect == Affect.DAMAGE:
		_damage(amount, incrementer, multiplier, type)
		return
	
	_heal(amount, incrementer, multiplier, type)


## Apply the specified amount of damage if damageable and not dead.
func _damage(amount: int, incrementer: int = 0, multiplier: float = 1.0, type: HealthActionType.Enum = HealthActionType.Enum.NONE) -> void:
	if not damageable:
		print_debug("%s cannot be damaged" % entity)
		not_damageable.emit(entity)
		return
	
	if is_dead():
		print_debug("%s is already dead" % entity)
		already_dead.emit(entity)
		return
	
	var applied := clampi(roundi((amount + incrementer) * multiplier), 0, current)
	if applied == current and not killable:
		print_debug("%s is not killable" % entity)
		not_killable.emit(entity)
		return

	var is_first_hit := is_full() and applied > 0
	current -= applied
	print_debug(
		"%s DAMAGE type=%s amount=%d incrementer=%d multiplier=%0.4f applied=%d current=%d"
		% [entity, HealthActionType.Enum.find_key(type), amount, incrementer, multiplier, applied, current]
	)
	damaged.emit(entity, type, amount, incrementer, multiplier, applied)

	var action := HealthAction.new(Affect.DAMAGE, type, amount)
	var modified_action := HealthModifiedAction.new(action, HealthModifier.new(incrementer, multiplier))
	action_applied.emit(modified_action, applied)
	
	if is_first_hit:
		print_debug("%s first hit" % entity)
		first_hit.emit(entity)
	
	if is_dead():
		print_debug("%s died" % entity)
		died.emit(entity)


## apply the specified amount of healing if healable, not full, or dead and revivable.
func _heal(amount: int, incrementer: int = 0, multiplier: float = 1.0, type: HealthActionType.Enum = HealthActionType.Enum.NONE) -> void:
	if not healable:
		print_debug("%s is not healable" % entity)
		not_healable.emit(entity)
		return
	
	if is_full():
		print_debug("%s already has full health" % entity)
		already_full.emit(entity)
		return
	
	if is_dead() and not revivable:
		print_debug("%s cannot be revived" % entity)
		not_revivable.emit(entity)
		return
	
	var notify_revived := is_dead() and amount > 0
	
	var applied := clampi(roundi((amount + incrementer) * multiplier), 0, max - current)
	current += applied
	print_debug(
		"%s HEAL type=%s amount=%d incrementer=%d multiplier=%0.4f applied=%d current=%d"
		% [entity, HealthActionType.Enum.find_key(type), amount, incrementer, multiplier, applied, current]
	)
	healed.emit(entity, type, amount, incrementer, multiplier, applied)

	var action := HealthAction.new(Affect.HEAL, type, amount)
	var modified_action := HealthModifiedAction.new(action, HealthModifier.new(incrementer, multiplier))
	action_applied.emit(modified_action, applied)
	
	if current == max and applied > 0:
		print_debug("%s has full health" % entity)
		full.emit(entity)
	
	if notify_revived:
		print_debug("%s revived" % entity)
		revived.emit(entity)


func _get_modifier(type: HealthActionType.Enum) -> HealthModifier:
	return modifiers.get(type, HealthModifier.new())
