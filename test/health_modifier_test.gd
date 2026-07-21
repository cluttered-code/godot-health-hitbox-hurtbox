class_name HealthModifierTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


func test_clone_is_equal_but_not_same() -> void:
	var original := HealthModifier.new(2, 1.5, Health.Affect.HEAL, HealthActionType.Enum.MEDICINE)
	var cloned: HealthModifier = original.clone()

	assert_object(cloned).is_not_same(original)
	assert_object(cloned).is_equal(HealthModifierMatcher.new(original))


func test_clone_mutation_is_independent() -> void:
	var original := HealthModifier.new(2, 1.5, Health.Affect.HEAL, HealthActionType.Enum.MEDICINE)
	var cloned: HealthModifier = original.clone()

	cloned.incrementer = 9
	cloned.multiplier = 0.1
	cloned.convert_affect = Health.Affect.DAMAGE

	assert_int(original.incrementer).is_equal(2)
	assert_float(original.multiplier).is_equal(1.5)
	assert_that(original.convert_affect).is_equal(Health.Affect.HEAL)
