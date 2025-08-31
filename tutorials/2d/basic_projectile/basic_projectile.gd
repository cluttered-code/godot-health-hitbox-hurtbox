class_name BasicProjectile extends Node2D

const SPEED: float = 250.0

@onready var hit_box: BasicHitBox2D = $BasicHitBox2D


func _ready() -> void:
	# Destroys this projectile after it hit something and applied actions
	hit_box.actions_applied.connect(destroy.unbind(1))
	# Destorys this projectile when it hits a wall
	hit_box.body_entered.connect(destroy.unbind(1))


func _physics_process(delta: float) -> void:
	# keep moving projectile forward
	position += transform.x * SPEED * delta


func destroy() -> void:
	hit_box.ignore_collisions = true
	queue_free()
