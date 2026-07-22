class_name HealthActionTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


func test_clone_is_equal_but_not_same() -> void:
	var original := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 25)
	var cloned: HealthAction = original.clone()

	assert_object(cloned).is_not_same(original)
	assert_object(cloned).is_equal(HealthActionMatcher.new(original))


func test_clone_mutation_is_independent() -> void:
	var original := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var cloned: HealthAction = original.clone()

	cloned.amount = 99
	cloned.affect = Health.Affect.HEAL

	assert_int(original.amount).is_equal(10)
	assert_that(original.affect).is_equal(Health.Affect.DAMAGE)
