class_name HitBox2D extends Area2D
## [HitBox2D] is associated with an object that can collide with a [HurtBox2D].

## emitted when collision with [HitBox2D] detected.
signal hit_box_entered(hit_box: HitBox2D)
## emitted when collision with [HurtBox2D] detected.
signal hurt_box_entered(hurt_box: HurtBox2D)
## emitted after the action is applied to a [HurtBox2D].
signal action_applied(hurt_box: HurtBox2D)
## emitted when collision with [Area2D] that isn't [HitBox2D] or [HurtBox2D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area2D)

## Array of [HealthAction] to be applied when [HurtBox2D] encountered.
@export var actions: Array[HealthAction] = [HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 1)]

## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [HitBox2D] or [HurtBox2D] and apply [Action].
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
	hurt_box_entered.emit(hurt_box)
	hurt_box.apply(actions)
	action_applied.emit(hurt_box)
