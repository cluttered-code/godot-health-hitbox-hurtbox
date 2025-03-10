class_name HitBox2D extends Area2D
## [HitBox2D] is associated with an object that can collide with a [BasicHurtBox2D].

## emitted when collision with [HitBox2D] detected.
signal hit_box_entered(hit_box: HitBox2D)
## emitted when collision with [BasicHurtBox2D] detected.
signal hurt_box_entered(hurt_box: BasicHurtBox2D)
## emitted after the action is applied to a [BasicHurtBox2D].
signal action_applied(hurt_box: BasicHurtBox2D)
## emitted when collision with [Area2D] that isn't [HitBox2D] or [BasicHurtBox2D].
## Can be using to detect things like environment.
signal unknown_area_entered(area: Area2D)


## The [Health.Affect] to be performed.
@export var affect: Health.Affect = Health.Affect.DAMAGE
## The amount of the action.
@export var amount: int = 1
## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [HitBox2D] or [BasicHurtBox2D] and apply appropriate action.
func _on_area_entered(area: Area2D) -> void:
	if ignore_collisions:
		return
	
	if area is HitBox2D:
		hit_box_entered.emit(area)
		return
	
	if area is not BasicHurtBox2D:
		unknown_area_entered.emit(area)
		return
	
	var hurt_box: BasicHurtBox2D = area
	hurt_box_entered.emit(hurt_box)
	_apply_action(hurt_box)
	action_applied.emit(hurt_box)


## Perfomes the [Health.Affect] on the specified [BasicHurtBox2D].
func _apply_action(hurt_box: BasicHurtBox2D) -> void:
	match affect:
		Health.Affect.DAMAGE:
			hurt_box.damage(amount)
		Health.Affect.HEAL:
			hurt_box.heal(amount)
