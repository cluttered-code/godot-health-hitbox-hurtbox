@tool
class_name HitBox3D extends Area3D
## [HitBox3D] is associated with an object that can collide with a [HurtBox3D].

## emitted when collision with [HitBox3D] detected.
signal hit_box_entered(hit_box: HitBox3D)
## emitted when collision with [HurtBox3D] detected.
signal hurt_box_entered(hurt_box: HurtBox3D)
## emitted after the action is applied to a [HurtBox3D].
signal action_applied(hurt_box: HurtBox3D)
## emitted when collision with [Area3D] that isn't [HitBox3D] or [HurtBox3D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area3D)


## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool

## [Modifer] applied to [HealthActionType.Enum].
@export var actions: Array[HealthAction] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [HitBox3D] or [HurtBox3D] and apply appropriate action.
func _on_area_entered(area: Area3D) -> void:
	if ignore_collisions:
		return
	
	if area is HitBox3D:
		hit_box_entered.emit(area)
		return
	
	if area is not HurtBox3D:
		unknown_area_entered.emit(area)
		return

	var hurt_box: HurtBox3D = area
	hurt_box_entered.emit(hurt_box)
	var cloned_actions := _clone_actions()
	hurt_box.apply_all_actions(cloned_actions)
	action_applied.emit(hurt_box)


func _clone_actions() -> Array[HealthAction]:
	var dup: Array[HealthAction]
	dup.assign(
		actions.map(
			func(action: HealthAction) -> HealthAction: return action.clone()
		)
	)

	return dup
