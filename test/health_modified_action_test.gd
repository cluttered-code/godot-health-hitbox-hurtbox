class_name HealthModifiedActionTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


func test_clone_is_deep() -> void:
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modifier := HealthModifier.new(1, 2.0, Health.Affect.HEAL)
	var original := HealthModifiedAction.new(action, modifier)

	var cloned: HealthModifiedAction = original.clone()

	assert_object(cloned).is_not_same(original)
	assert_object(cloned.action).is_not_same(original.action)
	assert_object(cloned.modifier).is_not_same(original.modifier)
	assert_object(cloned.action).is_equal(HealthActionMatcher.new(original.action))
	assert_object(cloned.modifier).is_equal(HealthModifierMatcher.new(original.modifier))


func test_clone_mutation_is_independent() -> void:
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modifier := HealthModifier.new(1, 2.0)
	var original := HealthModifiedAction.new(action, modifier)

	var cloned: HealthModifiedAction = original.clone()
	cloned.action.amount = 50
	cloned.modifier.multiplier = 9.0

	assert_int(original.action.amount).is_equal(10)
	assert_float(original.modifier.multiplier).is_equal(2.0)
