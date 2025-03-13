@tool
class_name HitScan2D extends RayCast2D
## [HitScan2D] interacts with [HurtBox2D] to affect [Health] components.

## emitted when collision with [HitBox2D] detected.
signal hit_box_entered(hit_box: HitBox2D)
## emitted when collision with [HurtBox2D] detected.
signal hurt_box_entered(hurt_box: HurtBox2D)
## emitted after the action is applied to a [HurtBox2D].
signal action_applied(hurt_box: HurtBox2D)
## emitted when collision with [Area2D] that isn't [HitBox2D] or [HurtBox2D].
## Used to detect things like environment.
signal unknown_area_entered(area: Area2D)


## [Modifer] applied to [HealthActionType.Enum].
@export var actions: Array[HealthAction] = []

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


## Detect collisions with [HurtBox2D] and apply appropriate action.
func fire() -> void:
	var collider = _collider if _collider else get_collider()
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
	hurt_box.apply_all_actions(actions)
	action_applied.emit(hurt_box)
