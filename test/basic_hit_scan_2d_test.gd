class_name BasicHitScan2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_hurt_box: BasicHurtBox2D
var hit_scan: BasicHitScan2D
var signals: Object


func before_test() -> void:
	mock_hurt_box = mock(BasicHurtBox2D)
	hit_scan = auto_free(BasicHitScan2D.new())
	add_child(hit_scan)
	signals = monitor_signals(hit_scan)


func test_fire_damage() -> void:
	hit_scan.affect = Health.Affect.DAMAGE
	hit_scan.amount = 10
	hit_scan._collider = mock_hurt_box

	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_fire_heal() -> void:
	hit_scan.affect = Health.Affect.HEAL
	hit_scan.amount = 10
	hit_scan._collider = mock_hurt_box

	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_fire_hit_box() -> void:
	var hit_box: BasicHitBox2D = auto_free(BasicHitBox2D.new())
	hit_scan._collider = hit_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted("hit_box_entered", [hit_box])


func test_fire_hit_box_ignore() -> void:
	var hit_box: BasicHitBox2D = auto_free(BasicHitBox2D.new())
	hit_box.ignore_collisions = true
	hit_scan._collider = hit_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])


func test_fire_area2d() -> void:
	var area: Area2D = auto_free(Area2D.new())
	hit_scan._collider = area
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted("unknown_area_entered", [area])
	
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])


func test_fire_null() -> void:
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).wait_until(50).is_not_emitted("unknown_area_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])
