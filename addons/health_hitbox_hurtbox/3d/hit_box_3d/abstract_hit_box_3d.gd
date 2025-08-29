@icon("res://addons/health_hitbox_hurtbox/3d/hit_box_3d/hit_box_3d.svg")
class_name AbstractHitBox3D extends Area3D
## [AbstractHitBox3D] is associated with an object that can collide with a [AbstractHurtBox3D].


## Emitted when collision with [AbstractHitBox3D] detected.
signal hit_box_entered(hit_box: AbstractHitBox3D)
## Emitted when collision with [AbstractHurtBox3D] detected.
signal hurt_box_entered(hurt_box: AbstractHurtBox3D)
## Emitted after the action is applied to a [AbstractHurtBox3D].
signal actions_applied(hurt_box: AbstractHurtBox3D)
## Emitted when collision with [Area3D] that isn't [AbstractHitBox3D] or [AbstractHurtBox3D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area3D)


## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool = false

## contains all actions to be applied by this [AbstractHitBox3D].
var _actions: Array[HealthAction] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [AbstractHitBox3D], [AbstractHurtBox3D], or [Area3D] and apply appropriate action.
func _on_area_entered(area: Area3D) -> void:
	if ignore_collisions:
		return
	
	if area is AbstractHitBox3D:
		hit_box_entered.emit(area)
		return
	
	if area is not AbstractHurtBox3D:
		unknown_area_entered.emit(area)
		return
	
	var hurt_box: AbstractHurtBox3D = area
	hurt_box_entered.emit(area)
	
	# FIX in godot 4.5: var dup_actions := _actions.duplicate_deep()
	var dup_actions: Array[HealthAction]
	dup_actions.assign(Utils.array_duplicate_deep(_actions))
	# ################################
	
	hurt_box.apply_all_actions(dup_actions)
	actions_applied.emit(hurt_box)
