class_name Projectile extends Node2D

const SPEED = 600

@onready var hit_box: BasicHitBox2D = $BasicHitBox2D

var amount: int:
	get(): return hit_box.amount
	set(value): hit_box.amount = value
	
var affect: Health.Affect:
	get(): return hit_box.affect
	set(value): hit_box.affect = value

func _ready() -> void:
	hit_box.hurt_box_entered.connect(_on_hurt_box_entered)


func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta


func _on_hurt_box_entered(_hurt_box: BasicHurtBox2D) -> void:
	hit_box.ignore_collisions = true
	queue_free()
