abstract class_name AbstractHitScan2D extends RayCast2D
## [AbstractHitScan2D] interacts with [AbstractHurtBox2D] to affect [Health] components

## emitted when collision with [AbstractHitBox2D] detected.
signal hit_box_entered(hit_box: AbstractHitBox2D)
## emitted when collision with [AbstractHurtBox2D] detected.
signal hurt_box_entered(hurt_box: AbstractHurtBox2D)
## emitted after the actions were applied to a [AbstractHurtBox2D].
signal actions_applied(hurt_box: AbstractHurtBox2D)
## emitted when collision with [Area2D] that isn't [AbstractHitBox2D] or [AbstractHurtBox2D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area2D)


var _actions: Array[HealthAction] = []

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


## duplicates all the actions related to this [AbstractHitBox2D]
func _duplicate_actions() -> Array[HealthAction]:
	return _actions.duplicate_deep()


## Detect collisions with [HurtBox2D] and apply appropriate action.
func fire() -> void:
	# get_collider() can't be mocked, _collider is set during tests
	var collider: Node = _collider if _collider else get_collider()
	if not collider:
		return
	
	if collider is HitBox2D:
		var hit_box: HitBox2D = collider
		if hit_box.ignore_collisions:
			return
		
		hit_box_entered.emit(collider)
		return
	
	if collider is not HurtBox2D:
		unknown_area_entered.emit(collider)
		return
	
	var hurt_box: HurtBox2D = collider
	hurt_box_entered.emit(hurt_box)
	var dup_actions := _actions.duplicate_deep()
	hurt_box.apply_all_actions(dup_actions)
	actions_applied.emit(hurt_box)
