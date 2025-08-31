class_name AdvancedHitBox2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const SIG_HURT_BOX_ENTERED := "hurt_box_entered"
const SIG_ACTIONS_APPLIED := "actions_applied"
const SIG_HIT_BOX_ENTERED := "hit_box_entered"
const SIG_UNKNOWN_AREA_ENTERED := "unknown_area_entered"


var mock_hurt_box: HurtBox2D
var hit_box: AdvancedHitBox2D
var action: HealthAction
var signals: Object


func before_test() -> void:
	mock_hurt_box = auto_free(mock(HurtBox2D))

	hit_box = auto_free(AdvancedHitBox2D.new())
	add_child(hit_box)

	action = auto_free(HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10))
	hit_box.actions.append(action)

	signals = monitor_signals(hit_box)


func test_on_area_entered_hurt_box() -> void:
	hit_box._on_area_entered(mock_hurt_box)
	
	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted(SIG_HURT_BOX_ENTERED, [mock_hurt_box])
	await assert_signal(signals).is_emitted(SIG_ACTIONS_APPLIED, [mock_hurt_box])

	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])


func test_on_area_entered_hit_box() -> void:
	hit_box._on_area_entered(hit_box)

	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted(SIG_HIT_BOX_ENTERED, [hit_box])

	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTIONS_APPLIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])


func test_on_area_entered_ignore() -> void:
	hit_box.ignore_collisions = true
	
	hit_box._on_area_entered(mock_hurt_box)
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_UNKNOWN_AREA_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTIONS_APPLIED, [any()])


func test_on_area_entered_area() -> void:
	var area: Area2D = auto_free(Area2D.new())
	
	hit_box._on_area_entered(area)
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted(SIG_UNKNOWN_AREA_ENTERED, [area])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HURT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HIT_BOX_ENTERED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTIONS_APPLIED, [any()])
