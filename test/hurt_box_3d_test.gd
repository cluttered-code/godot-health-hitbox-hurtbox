class_name HurtBox3DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_health: Health
var hurt_box: HurtBox3D

func before_test() -> void:
	mock_health = auto_free(mock(Health))
	
	hurt_box = auto_free(HurtBox3D.new())
	hurt_box.health = mock_health
	add_child(hurt_box)


func test_damage() -> void:
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.KINETIC])
	assert_int(modified_action.affect).is_equal(Health.Affect.DAMAGE)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_damage_modifier() -> void:
	hurt_box._modifiers[HealthActionType.Enum.KINETIC].multiplier = 1.5
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.KINETIC])
	assert_float(modified_action.multiplier).is_equal(1.5)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_damage_no_health() -> void:
	hurt_box.health = null
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	
	await assert_error(func(): hurt_box.apply_all_actions([action]))\
			.is_push_error("%s is missing a 'Health' component" % hurt_box)
	
	verify_no_interactions(mock_health)


func test_damage_negative_modifier() -> void:
	hurt_box.damage_multiplier = -1.0
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.KINETIC])
	assert_float(modified_action.multiplier).is_equal(-1.0)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_heal_on_damage() -> void:
	hurt_box.heal_on_damage = true
	assert_bool(hurt_box.heal_on_damage).is_true()
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.KINETIC])
	assert_int(modified_action.affect).is_equal(Health.Affect.HEAL)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_heal() -> void:
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.MEDICINE])
	assert_int(modified_action.affect).is_equal(Health.Affect.HEAL)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_heal_modifier() -> void:
	hurt_box.heal_multiplier = 2.4
	
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.MEDICINE])
	assert_float(modified_action.modifier.multiplier).is_equal(2.4)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_heal_no_health() -> void:
	hurt_box.health = null
	
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	
	await assert_error(func(): hurt_box.apply_all_actions([action]))\
			.is_push_error("%s is missing a 'Health' component" % hurt_box)
	
	verify_no_interactions(mock_health)


func test_heal_negative_modifier() -> void:
	hurt_box.heal_multiplier = -1.0
	
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.MEDICINE])
	assert_float(modified_action.multiplier).is_equal(-1.0)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_damage_on_heal() -> void:
	hurt_box.damage_on_heal = true
	assert_bool(hurt_box.damage_on_heal).is_true()
	
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var modified_action := HealthModifiedAction.new(action, hurt_box._modifiers[HealthActionType.Enum.MEDICINE])
	assert_int(modified_action.affect).is_equal(Health.Affect.DAMAGE)
	
	hurt_box.apply_all_actions([action])
	
	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])
