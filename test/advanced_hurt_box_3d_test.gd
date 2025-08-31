class_name AdvancedHurtBox3DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_health: Health
var hurt_box: AdvancedHurtBox3D
var kinetic_modifier: HealthModifier
var medicine_modifier: HealthModifier

func before_test() -> void:
	mock_health = auto_free(mock(Health))

	kinetic_modifier = HealthModifier.new(1, 2.0, Health.Affect.HEAL)
	medicine_modifier = HealthModifier.new(0, 1.0, Health.Affect.HEAL, HealthActionType.Enum.KINETIC)
	
	hurt_box = auto_free(AdvancedHurtBox3D.new())
	hurt_box.health = mock_health
	hurt_box.modifiers[HealthActionType.Enum.KINETIC] = kinetic_modifier
	hurt_box.modifiers[HealthActionType.Enum.MEDICINE] = medicine_modifier
	add_child(hurt_box)


func test_kinetic_action() -> void:
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var modified_action := HealthModifiedAction.new(action, kinetic_modifier)

	hurt_box.apply_all_actions([action])

	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_medecine_action() -> void:
	var action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var modified_action := HealthModifiedAction.new(action, medicine_modifier)

	hurt_box.apply_all_actions([action])

	verify(mock_health, 1).apply_all_modified_actions([HealthModifiedActionMatcher.new(modified_action)])


func test_kinetic_and_medecine_actions() -> void:
	var k_action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 10)
	var k_modified_action := HealthModifiedAction.new(k_action, kinetic_modifier)

	var h_action := HealthAction.new(Health.Affect.HEAL, HealthActionType.Enum.MEDICINE, 10)
	var h_modified_action := HealthModifiedAction.new(h_action, medicine_modifier)

	hurt_box.apply_all_actions([k_action, h_action])

	verify(mock_health, 1).apply_all_modified_actions([
		HealthModifiedActionMatcher.new(k_modified_action),
		HealthModifiedActionMatcher.new(h_modified_action)
	])
