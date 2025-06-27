class_name BasicHurtBox2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_health: Health
var hurt_box: BasicHurtBox2D

func before_test() -> void:
	mock_health = auto_free(mock(Health))
	
	hurt_box = auto_free(BasicHurtBox2D.new())
	hurt_box.health = mock_health
	add_child(hurt_box)


func test_defaults() -> void:
	var modifier := HealthModifier.new()

	assert_object(hurt_box._modifiers[HealthActionType.Enum.KINETIC]).is_equal(HealthModifierMatcher.new(modifier))
	assert_object(hurt_box._modifiers[HealthActionType.Enum.MEDICINE]).is_equal(HealthModifierMatcher.new(modifier))


func test_damage_multiplier() -> void:
	var modifier := HealthModifier.new()
	modifier.multiplier = 6.9

	hurt_box.damage_multiplier = 6.9

	assert_object(hurt_box._modifiers[HealthActionType.Enum.KINETIC]).is_equal(HealthModifierMatcher.new(modifier))


func test_heal_on_damage() -> void:
	var modifier := HealthModifier.new()
	modifier.convert_affect = Health.Affect.HEAL

	hurt_box.heal_on_damage = true

	assert_object(hurt_box._modifiers[HealthActionType.Enum.KINETIC]).is_equal(HealthModifierMatcher.new(modifier))


func test_heal_multiplier() -> void:
	var modifier := HealthModifier.new()
	modifier.multiplier = 4.2

	hurt_box.heal_multiplier = 4.2

	assert_object(hurt_box._modifiers[HealthActionType.Enum.MEDICINE]).is_equal(HealthModifierMatcher.new(modifier))


func test_damage_on_heal() -> void:
	var modifier := HealthModifier.new()
	modifier.convert_affect = Health.Affect.DAMAGE

	hurt_box.damage_on_heal = true

	assert_object(hurt_box._modifiers[HealthActionType.Enum.MEDICINE]).is_equal(HealthModifierMatcher.new(modifier))
