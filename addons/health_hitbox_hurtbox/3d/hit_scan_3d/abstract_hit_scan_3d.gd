@icon("res://addons/health_hitbox_hurtbox/3d/hit_scan_3d/hit_scan_3d.svg")
class_name AbstractHitScan3D extends RayCast3D
## [AbstractHitScan3D] interacts with [AbstractHurtBox3D] to affect [Health] components

## emitted when collision with [AbstractHitBox3D] detected.
signal hit_box_entered(hit_box: AbstractHitBox3D)
## emitted when collision with [AbstractHurtBox3D] detected.
signal hurt_box_entered(hurt_box: AbstractHurtBox3D)
## emitted after the actions were applied to a [AbstractHurtBox3D].
signal actions_applied(hurt_box: AbstractHurtBox3D)
## emitted when collision with [Area3D] that isn't [AbstractHitBox3D] or [AbstractHurtBox3D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area3D)


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


## Detect collisions with [HurtBox3D] and apply appropriate action.
func fire() -> void:
	# get_collider() can't be mocked, _collider is set during tests
	var collider: Node = _collider if _collider else get_collider()
	if not collider:
		return
	
	if collider is AbstractHitBox3D:
		var hit_box: AbstractHitBox3D = collider
		if hit_box.ignore_collisions:
			return
		
		hit_box_entered.emit(collider)
		return
	
	if collider is not AbstractHurtBox3D:
		unknown_area_entered.emit(collider)
		return
	
	var hurt_box: AbstractHurtBox3D = collider
	hurt_box_entered.emit(hurt_box)
	
	# FIX in godot 4.5: var dup_actions := _actions.duplicate_deep()
	var dup_actions: Array[HealthAction]
	dup_actions.assign(Utils.array_duplicate_deep(_actions))
	# ################################
	
	hurt_box.apply_all_actions(dup_actions)
	actions_applied.emit(hurt_box)
