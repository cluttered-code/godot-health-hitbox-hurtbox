class_name Health extends Node
## Health is used to track an entity's health, death, and revival.


## Affect an action will have on [Health].
enum Affect { NONE, DAMAGE, HEAL }

## Emitted after damage is applied.
signal damaged(entity: Node, amount: int, applied: int, multiplier: float)
## Emitted after damage is applied when death has occured.
signal died(entity: Node)

## Emitted after healing is applied.
signal healed(entity: Node, amount: int, applied: int, multiplier: float)
## Emitted after healing is applied when dead.
signal revived(entity: Node)


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
func fill_health() -> void:
	heal(max - current)


## Apply the specified amount of damage if damageable and not dead.
func damage(amount: int, multiplier: float = 1.0) -> void:
	if not damageable:
		print_debug("%s cannot be damaged" % entity)
		not_damageable.emit(entity)
		return
	
	if is_dead():
		print_debug("%s is already dead" % entity)
		already_dead.emit(entity)
		return
	
	var applied := clampi(roundi(amount * multiplier), 0, current)
	if applied == current and not killable:
		print_debug("%s is not killable" % entity)
		not_killable.emit(entity)
		return

	var is_first_hit := is_full() and applied > 0
	current -= applied
	print_debug("%s damaged amount=%d multiplier=%0.4f applied=%d current=%d" % [entity, amount, multiplier, applied, current])
	damaged.emit(entity, amount, applied, multiplier)
	
	if is_first_hit:
		print_debug("%s first hit" % entity)
		first_hit.emit(entity)
	
	if is_dead():
		print_debug("%s died" % entity)
		died.emit(entity)


## apply the specified amount of healing if healable, not full, or dead and revivable.
func heal(amount: int, multiplier: float = 1.0) -> void:
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
	
	var applied := clampi(roundi(amount * multiplier), 0, max - current)
	current += applied
	print_debug("%s healed amount=%d multiplier=%0.4f applied=%d current=%d" % [entity, amount, multiplier, applied, current])
	healed.emit(entity, amount, applied, multiplier)
	
	if current == max and applied > 0:
		print_debug("%s has full health" % entity)
		full.emit(entity)
	
	if notify_revived:
		print_debug("%s revived" % entity)
		revived.emit(entity)
