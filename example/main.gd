extends Node

var projectile_scene = preload("res://example/projectile/projectile.tscn")


func _ready() -> void:
	$HeadTimer.timeout.connect(_on_head_timeout)
	$BodyTimer.timeout.connect(_on_body_timeout)
	
	%Damageable.pressed.connect(_on_damageable_pressed.bind(%Damageable))
	%Healable.pressed.connect(_on_healable_pressed.bind(%Healable))
	%Killable.pressed.connect(_on_killable_pressed.bind(%Killable))
	%Revivable.pressed.connect(_on_revivable_pressed.bind(%Revivable))
	
	%HeadHitScan.pressed.connect(_on_head_hit_scan)
	%BodyHitScan.pressed.connect(_on_body_hit_scan)
	
	%HeadHitBox.pressed.connect(_on_head_hit_box)
	%BodyHitBox.pressed.connect(_on_body_hit_box)
	
	%Heal.pressed.connect(_on_heal_pressed)
	
	$Player.health.damaged.connect(_on_player_damaged)
	$Player.health.healed.connect(_on_player_healed)
	$Player.health.died.connect(_on_player_died)
	$Player.health.revived.connect(_on_player_revived)


func _on_damageable_pressed(button: CheckButton) -> void:
	$Player.health.damageable = button.button_pressed


func _on_healable_pressed(button: CheckButton) -> void:
	$Player.health.healable = button.button_pressed


func _on_killable_pressed(button: CheckButton) -> void:
	$Player.health.killable = button.button_pressed


func _on_revivable_pressed(button: CheckButton) -> void:
	$Player.health.revivable = button.button_pressed


func _on_head_hit_scan() -> void:
	$HeadHitScan2D.amount = %HeadHitScanAmount.value
	$HeadHitScan2D.affect = Health.Affect.DAMAGE
	$HeadLine2D.visible = true
	_restart_timer($HeadTimer)
	$HeadHitScan2D.fire()


func _on_body_hit_scan() -> void:
	$BodyHitScan2D.amount = %BodyHitScanAmount.value
	$BodyHitScan2D.affect = Health.Affect.DAMAGE
	$BodyLine2D.visible = true
	_restart_timer($BodyTimer)
	$BodyHitScan2D.fire()
	


func _on_head_hit_box() -> void:
	var projectile := projectile_scene.instantiate()
	projectile.position = $HeadMarker2D.position
	add_child(projectile)
	projectile.amount = %HeadHitBoxAmount.value
	projectile.affect = Health.Affect.DAMAGE
	


func _on_body_hit_box() -> void:
	var projectile := projectile_scene.instantiate()
	projectile.position = $BodyMarker2D.position
	add_child(projectile) # add here since hit_box on ready
	projectile.amount = %BodyHitBoxAmount.value
	projectile.affect = Health.Affect.DAMAGE
	


func _restart_timer(timer: Timer) -> void:
	timer.stop()
	timer.start()


func _on_head_timeout() -> void:
	$HeadLine2D.visible = false


func _on_body_timeout() -> void:
	$BodyLine2D.visible = false


func _on_heal_pressed() -> void:
	$Player.health.heal(%HealAmount.value)
	

func _on_player_damaged(_entity: Node, amount: int, applied: int, multiplier: float) -> void:
	%LastAction.text = "DAMAGE amount=%d applied=%d multiplier=%0.1f" % [amount, applied, multiplier]


func _on_player_healed(_entity: Node, amount: int, applied: int, multiplier: float) -> void:
	%LastAction.text = "HEAL amount=%d applied=%d multiplier=%0.1f" % [amount, applied, multiplier]


func _on_player_died(_player: Node) -> void:
	%Status.text = "Dead"


func _on_player_revived(_player: Node) -> void:
	%Status.text = "Alive"
