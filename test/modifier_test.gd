class_name ModifierTest extends GdUnitTestSuite


func test_defaults() -> void:
	var modifier := HealthModifier.new()
	assert_int(modifier.incrementer).is_equal(0)
	assert_float(modifier.multiplier).is_equal(1.0)
	assert_int(modifier.convert_affect).is_equal(Health.Affect.NONE)
	assert_int(modifier.convert_type).is_equal(HealthActionType.Enum.NONE)


func test_constructor() -> void:
	var modifier := HealthModifier.new(5, 2.0, Health.Affect.DAMAGE, HealthActionType.Enum.MEDICINE)
	assert_int(modifier.incrementer).is_equal(5)
	assert_float(modifier.multiplier).is_equal(2.0)
	assert_int(modifier.convert_affect).is_equal(Health.Affect.DAMAGE)
	assert_int(modifier.convert_type).is_equal(HealthActionType.Enum.MEDICINE)


func test_duplicate() -> void:
	var modifier := HealthModifier.new()
	var dup: HealthModifier = modifier.duplicate()
	assert_object(modifier).is_not_same(dup)
	assert_object(modifier).is_equal(dup)
	
	dup.incrementer = 42
	dup.multiplier = 0.8
	dup.convert_affect = Health.Affect.HEAL
	dup.convert_type = HealthActionType.Enum.KINETIC
	assert_object(modifier).is_not_equal(dup)
