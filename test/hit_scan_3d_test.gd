class_name HitScan3DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_hurt_box: HurtBox3D
var hit_scan: HitScan3D
var signals: Object


func before_test() -> void:
	mock_hurt_box = mock(HurtBox3D)
	hit_scan = auto_free(HitScan3D.new())
	signals = monitor_signals(hit_scan)


func test_fire_damage() -> void:
	hit_scan.affect = Health.Affect.DAMAGE
	hit_scan.amount = 10
	hit_scan._collider = mock_hurt_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 1).damage(10)
	verify(mock_hurt_box, 0).heal(any_int())
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_fire_heal() -> void:
	hit_scan.affect = Health.Affect.HEAL
	hit_scan.amount = 10
	hit_scan._collider = mock_hurt_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).damage(any_int())
	verify(mock_hurt_box, 1).heal(10)
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_fire_hit_box() -> void:
	var hit_box: HitBox3D = auto_free(HitBox3D.new())
	hit_scan._collider = hit_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).damage(any_int())
	verify(mock_hurt_box, 0).heal(any_int())
	
	await assert_signal(signals).is_emitted("hit_box_entered", [hit_box])


func test_fire_hit_box_ignore() -> void:
	var hit_box: HitBox3D = auto_free(HitBox3D.new())
	hit_box.ignore_collisions = true
	hit_scan._collider = hit_box
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).damage(any_int())
	verify(mock_hurt_box, 0).heal(any_int())
	
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])


func test_fire_area3d() -> void:
	var area: Area3D = auto_free(Area3D.new())
	hit_scan._collider = area
	
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).damage(any_int())
	verify(mock_hurt_box, 0).heal(any_int())
	
	await assert_signal(signals).is_emitted("unknown_area_entered", [area])
	
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])


func test_fire_null() -> void:
	hit_scan.fire()
	
	verify(mock_hurt_box, 0).damage(any_int())
	verify(mock_hurt_box, 0).heal(any_int())
	
	await assert_signal(signals).wait_until(50).is_not_emitted("unknown_area_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])
