@tool
class_name BasicHitScan3D extends RayCast3D
## BasicHitScan3D interacts with [BasicHurtBox3D] to affect [Health] components.

## emitted when collision with [BasicHitBox3D] detected.
signal hit_box_entered(hit_box: BasicHitBox3D)
## emitted when collision with [BasicHurtBox3D] detected.
signal hurt_box_entered(hurt_box: BasicHurtBox3D)
## emitted after the action is applied to a [BasicHurtBox3D].
signal action_applied(hurt_box: BasicHurtBox3D)
## emitted when collision with [Area3D] that isn't [BasicHitBox3D] or [BasicHurtBox3D].
## Used to detect things like environment.
signal unknown_area_entered(area: Area3D)


## [Modifer] applied to [HealthActionType.Enum].
var _actions: Array[HealthAction] = [
	HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 1)
]


## The [Health.Affect] to be performed.
@export var affect: Health.Affect = Health.Affect.DAMAGE:
	get():
		return _actions[0].affect
	set(affect):
		_actions[0].affect = affect
		_actions[0].type = HealthActionType.Enum.KINETIC if affect == Health.Affect.DAMAGE else HealthActionType.Enum.MEDICINE

## The amount of the action.
@export var amount: int = 1:
	get():
		return _actions[0].amount
	set(amount):
		_actions[0].amount = amount

# Here for testing, can't mock native node functions
var _collider: Node


func _enter_tree() -> void:
	# override default in editor
	if Engine.is_editor_hint():
		collide_with_areas = true


func _set(property: StringName, value: Variant) -> bool:
	# allow setting anything in game
	if not Engine.is_editor_hint():
		return false
	
	match property:
		# force collide_with_area in editor
		"collide_with_areas":
			collide_with_areas = true
		_:
			return false
	
	return true


## Detect collisions with [BasicHurtBox3D] and apply appropriate action.
func fire() -> void:
	var collider = _collider if _collider else get_collider()
	if not collider:
		return
	
	if collider is BasicHitBox3D:
		var hit_box: BasicHitBox3D = collider
		if hit_box.ignore_collisions:
			return
		hit_box_entered.emit(collider)
		return
	
	if collider is not BasicHurtBox3D:
		unknown_area_entered.emit(collider)
		return
	
	var hurt_box: BasicHurtBox3D = collider
	hurt_box_entered.emit(hurt_box)
	hurt_box.apply_all_actions(_actions)
	action_applied.emit(hurt_box)
