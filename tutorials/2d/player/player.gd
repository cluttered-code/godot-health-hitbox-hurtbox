class_name Player extends CharacterBody2D

const BASIC_PROJECTILE = preload("res://tutorials/2d/basic_projectile/basic_projectile.tscn")

@export var speed: float = 80.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_sprite: Sprite2D = $GunSprite2D
@onready var muzzle_marker: Marker2D = %MuzzleMarker2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shoot"):
		var projectile := BASIC_PROJECTILE.instantiate()
		owner.add_child(projectile)
		projectile.transform = muzzle_marker.global_transform


func _physics_process(_delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	_flip_toward_mouse(mouse_position)
	gun_sprite.look_at(mouse_position)
	
	_update_velocity()
	move_and_slide()
	
	_update_animation()


func _flip_toward_mouse(mouse_position: Vector2) -> void:
	# ALERT: using != and inverting subtraction causes jitter at crossover
	if signf(transform.x.x) == signf(global_position.x - mouse_position.x):
		transform.x *= Transform2D.FLIP_X


func _update_velocity() -> void:
	var input := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = input * speed


func _update_animation() -> void:
	if velocity.is_zero_approx():
		animated_sprite.play(&"idle")
		return
	
	animated_sprite.play(&"walk")
