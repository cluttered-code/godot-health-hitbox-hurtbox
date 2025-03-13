class_name HitScan2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const SIG_HURT_BOX_ENTERED := "hurt_box_entered"
const SIG_ACTION_APPLIED := "action_applied"
const SIG_HIT_BOX_ENTERED := "hit_box_entered"
const SIG_UNKNOWN_AREA_ENTERED := "unknown_area_entered"

var mock_hurt_box: HurtBox2D
var hit_scan: HitScan2D
var action: HealthAction
var signals: Object


func before_test() -> void:
	mock_hurt_box = mock(HurtBox2D)
	hit_scan = auto_free(HitScan2D.new())
	add_child(hit_scan)

	action = auto_free(HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10))
	hit_scan.actions.append(action)

	signals = monitor_signals(hit_scan)


func test_fire_hurt_box() -> void:
	hit_scan._collider = mock_hurt_box

	hit_scan.fire()

	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted(SIG_HURT_BOX_ENTERED, [mock_hurt_box])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [mock_hurt_box])

	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])


func test_fire_hit_box() -> void:
	var hit_box: HitBox2D = auto_free(HitBox2D.new())
	hit_scan._collider = hit_box

	hit_scan.fire()

	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted(SIG_HIT_BOX_ENTERED, [hit_box])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])


func test_fire_hit_box_ignore() -> void:
	var hit_box: HitBox2D = auto_free(HitBox2D.new())
	hit_box.ignore_collisions = true
	hit_scan._collider = hit_box

	hit_scan.fire()

	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])


func test_fire_area() -> void:
	var area: Area2D = auto_free(Area2D.new())
	hit_scan._collider = area

	hit_scan.fire()

	verify(mock_hurt_box, 0).apply_all_actions(any_array())

	await assert_signal(signals).is_emitted(SIG_UNKNOWN_AREA_ENTERED, [area])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any()])
