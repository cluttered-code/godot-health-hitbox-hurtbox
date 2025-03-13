class_name BasicProjectile extends Node2D

const SPEED: float = 250.0

@onready var hit_box: BasicHitBox2D = $BasicHitBox2D


func _ready() -> void:
	hit_box.action_applied.connect(_on_action_applied)
	hit_box.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta


func destory() -> void:
	hit_box.ignore_collisions = true
	queue_free()


func _on_action_applied(_hurt_box: BasicHurtBox2D) -> void:
	destory()


func _on_body_entered(_body: Node2D) -> void:
	destory()
