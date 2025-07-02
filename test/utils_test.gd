class_name UtilsTest extends GdUnitTestSuite


func test_array_duplicate_deep() -> void:
	var actions: Array[HealthAction] = [HealthAction.new()]
	var dups: Array[HealthAction]
	dups.assign(Utils.array_duplicate_deep(actions))
	assert_array(actions).is_not_same(dups)
	assert_object(actions[0]).is_not_same(dups[0])
	assert_object(actions[0]).is_equal(dups[0])
	
	dups[0].amount = 42
	assert_object(actions[0]).is_not_equal(dups[0])
