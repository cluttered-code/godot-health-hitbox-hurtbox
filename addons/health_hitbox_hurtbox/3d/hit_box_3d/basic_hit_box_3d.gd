class_name BasicHitBox3D extends Area3D
## [BasicHitBox3D] is associated with an object that can collide with a [BasicHurtBox3D].

## emitted when collision with [BasicHitBox3D] detected.
signal hit_box_entered(hit_box: BasicHitBox3D)
## emitted when collision with [BasicHurtBox3D] detected.
signal hurt_box_entered(hurt_box: BasicHurtBox3D)
## emitted after the action is applied to a [BasicHurtBox3D].
signal action_applied(hurt_box: BasicHurtBox3D)
## emitted when collision with [Area3D] that isn't [BasicHitBox3D] or [BasicHurtBox3D].
## Can be using to detect things like environment.
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

## Ignore collisions when [color=orange]true[/color].[br]
## Set this to [color=orange]true[/color] after a collision is detected to avoid
## further collisions.[br]
## It is recommended to set this to [color=orange]true[/color] before calling
## [color=orange]queue_free()[/color] to avoid further collisions.
@export var ignore_collisions: bool


func _ready() -> void:
	area_entered.connect(_on_area_entered)


## Detect collisions with [BasicHitBox3D] or [BasicHurtBox3D] and apply appropriate action.
func _on_area_entered(area: Area3D) -> void:
	if ignore_collisions:
		return
	
	if area is BasicHitBox3D:
		hit_box_entered.emit(area)
		return
	
	if area is not BasicHurtBox3D:
		unknown_area_entered.emit(area)
		return
	
	var hurt_box: BasicHurtBox3D = area
	hurt_box_entered.emit(hurt_box)
	hurt_box.apply_all_actions(_actions)
	action_applied.emit(hurt_box)
