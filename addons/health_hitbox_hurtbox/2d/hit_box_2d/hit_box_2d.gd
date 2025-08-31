@icon("res://addons/health_hitbox_hurtbox/2d/hit_box_2d/hit_box_2d.svg")
class_name HitBox2D extends Area2D
## [HitBox2D] is and abstract class associated with an object that can collide with a [HurtBox2D].


## Emitted when collision with [HitBox2D] detected.
signal hit_box_entered(hit_box: HitBox2D)
## Emitted when collision with [HurtBox2D] detected.
signal hurt_box_entered(hurt_box: HurtBox2D)
## Emitted after actions are applied to a [HurtBox2D].
signal actions_applied(hurt_box: HurtBox2D)
## Emitted when collision with [Area2D] that isn't [HitBox2D] or [HurtBox2D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area2D)


## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions within the same processing loop because queue_free() won't
## execute until after the loop.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool = false

## contains all actions to be applied by this [HitBox2D].
var _actions: Array[HealthAction] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [HitBox2D], [HurtBox2D], or [Area2D] and apply appropriate action.
func _on_area_entered(area: Area2D) -> void:
	if ignore_collisions:
		return

	if area is HitBox2D:
		hit_box_entered.emit(area)
		return

	if area is not HurtBox2D:
		unknown_area_entered.emit(area)
		return

	var hurt_box: HurtBox2D = area
	hurt_box_entered.emit(area)

	# FIX in godot 4.5: var dup_actions := _actions.duplicate_deep()
	var dup_actions: Array[HealthAction]
	dup_actions.assign(Utils.array_duplicate_deep(_actions))
	# ################################

	hurt_box.apply_all_actions(dup_actions)
	actions_applied.emit(hurt_box)
