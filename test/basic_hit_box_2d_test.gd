class_name BasicHitBox2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_hurt_box: BasicHurtBox2D
var hit_box: BasicHitBox2D


func before_test() -> void:
	mock_hurt_box = auto_free(mock(BasicHurtBox2D))
	hit_box = auto_free(BasicHitBox2D.new())
	add_child(hit_box)


func test_defaults() -> void:
	var action := HealthAction.new()
	assert_int(hit_box.actions.size()).is_equal(1)
	assert_object(hit_box.actions[0]).is_equal(HealthActionMatcher.new(action))


func test_affect() -> void:
	hit_box.affect = Health.Affect.HEAL

	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE)
	assert_int(hit_box.actions.size()).is_equal(1)
	assert_object(hit_box.actions[0]).is_equal(HealthActionMatcher.new(action))


func test_amount() -> void:
	hit_box.amount = 25

	var action := HealthAction.new()
	action.amount = 25
	assert_int(hit_box.actions.size()).is_equal(1)
	assert_object(hit_box.actions[0]).is_equal(HealthActionMatcher.new(action))
