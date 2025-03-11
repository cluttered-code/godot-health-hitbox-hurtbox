class_name HitBox3DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_hurt_box: HurtBox3D
var hit_box: HitBox3D
var signals: Object


func before_test() -> void:
	mock_hurt_box = auto_free(mock(HurtBox3D))
	hit_box = auto_free(HitBox3D.new())
	signals = monitor_signals(hit_box)


func test_on_area_entered_damage() -> void:
	hit_box.affect = Health.Affect.DAMAGE
	hit_box.amount = 10

	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	
	hit_box._on_area_entered(mock_hurt_box)
	
	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_on_area_entered_heal() -> void:
	hit_box.affect = Health.Affect.HEAL
	hit_box.amount = 10

	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	
	hit_box._on_area_entered(mock_hurt_box)
	
	verify(mock_hurt_box, 1).apply_all_actions([HealthActionMatcher.new(action)])
	
	await assert_signal(signals).is_emitted("hurt_box_entered", [mock_hurt_box])
	await assert_signal(signals).is_emitted("action_applied", [mock_hurt_box])


func test_on_area_entered_hit_box() -> void:
	hit_box._on_area_entered(hit_box)
	
	await assert_signal(signals).is_emitted("hit_box_entered", [hit_box])


func test_on_area_entered_ignore() -> void:
	hit_box.ignore_collisions = true
	hit_box.affect = Health.Affect.DAMAGE
	hit_box.amount = 10
	
	hit_box._on_area_entered(mock_hurt_box)
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).wait_until(50).is_not_emitted("unknown_area_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])


func test_on_area_entered_area2d() -> void:
	hit_box.affect = Health.Affect.DAMAGE
	hit_box.amount = 10
	
	var area: Area3D = auto_free(Area3D.new())
	
	hit_box._on_area_entered(area)
	
	verify(mock_hurt_box, 0).apply_all_actions(any_array())
	
	await assert_signal(signals).is_emitted("unknown_area_entered", [area])
	
	await assert_signal(signals).wait_until(50).is_not_emitted("hurt_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("hit_box_entered", [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted("action_applied", [any()])
