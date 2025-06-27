class_name BasicHitScan3DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_hurt_box: BasicHurtBox3D
var hit_scan: BasicHitScan3D
var signals: Object


func before_test() -> void:
	mock_hurt_box = mock(BasicHurtBox3D)
	hit_scan = auto_free(BasicHitScan3D.new())
	add_child(hit_scan)
	signals = monitor_signals(hit_scan)


func test_defaults() -> void:
	var action := HealthAction.new()
	assert_int(hit_scan._actions.size()).is_equal(1)
	assert_object(hit_scan._actions[0]).is_equal(HealthActionMatcher.new(action))


func test_affect() -> void:
	hit_scan.affect = Health.Affect.HEAL

	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE)
	assert_int(hit_scan._actions.size()).is_equal(1)
	assert_object(hit_scan._actions[0]).is_equal(HealthActionMatcher.new(action))


func test_amount() -> void:
	hit_scan.amount = 25

	var action := HealthAction.new()
	action.amount = 25
	assert_int(hit_scan._actions.size()).is_equal(1)
	assert_object(hit_scan._actions[0]).is_equal(HealthActionMatcher.new(action))
