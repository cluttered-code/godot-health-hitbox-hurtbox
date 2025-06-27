class_name ActionTest extends GdUnitTestSuite


func test_defaults() -> void:
	var action := HealthAction.new()
	assert_int(action.affect).is_equal(Health.Affect.DAMAGE)
	assert_int(action.type).is_equal(HealthActionType.Enum.KINETIC)
	assert_int(action.amount).is_equal(1)


func test_constructor() -> void:
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 25)
	assert_int(action.affect).is_equal(Health.Affect.HEAL)
	assert_int(action.type).is_equal(HealthActionType.Enum.MEDICINE)
	assert_int(action.amount).is_equal(25)


func test_duplicate() -> void:
	var action := HealthAction.new()
	var dup: HealthAction = action.duplicate()
	assert_object(action).is_not_same(dup)
	assert_object(action).is_equal(dup)
	
	dup.affect = Health.Affect.HEAL
	dup.type = HealthActionType.Enum.MEDICINE
	dup.amount = 10
	assert_object(action).is_not_equal(dup)


func test_array_duplicate_deep() -> void:
	var actions: Array[HealthAction] = [HealthAction.new()]
	var dups: Array[HealthAction] = actions.duplicate_deep()
	assert_array(actions).is_not_same(dups)
	assert_object(actions[0]).is_not_same(dups[0])
	assert_object(actions[0]).is_equal(dups[0])
	
	dups[0].amount = 42
	assert_object(actions[0]).is_not_equal(dups[0])
