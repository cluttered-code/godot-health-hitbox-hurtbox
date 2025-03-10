class_name HurtBox2DTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var mock_health: Health
var hurt_box: BasicHurtBox2D

func before_test() -> void:
	mock_health = auto_free(mock(Health))
	hurt_box = auto_free(BasicHurtBox2D.new())
	hurt_box.health = mock_health
	add_child(hurt_box)


func test_damage() -> void:
	hurt_box.damage(10)
	
	verify(mock_health, 1).damage(10, 0, 1.0, HealthActionType.Enum.NONE)


func test_damage_modifier() -> void:
	hurt_box.damage_multiplier = 1.5
	hurt_box.damage(10)
	
	verify(mock_health, 1).damage(10, 0, 1.5)


func test_damage_no_health() -> void:
	hurt_box.health = null
	
	await assert_error(func(): hurt_box.damage(10))\
			.is_push_error("%s is missing a 'Health' component" % hurt_box)
	
	verify_no_interactions(mock_health)


func test_damage_modifier_zero() -> void:
	hurt_box.damage_multiplier = 0.0
	hurt_box.damage(10)
	
	verify_no_interactions(mock_health)


func test_damage_negative_modifier() -> void:
	hurt_box.damage_multiplier = -1.0
	hurt_box.damage(10)
	
	verify(mock_health, 1).damage(10, 0, -1.0)


func test_heal_on_damage() -> void:
	hurt_box.heal_on_damage = true
	hurt_box.damage(10)
	
	verify(mock_health, 1).heal(10, 0, 1.0)


func test_heal() -> void:
	hurt_box.heal(10)
	
	verify(mock_health, 1).heal(10, 0, 1.0, HealthActionType.Enum.NONE)


func test_heal_modifier() -> void:
	hurt_box.heal_multiplier = 2.4
	hurt_box.heal(10)
	
	verify(mock_health, 1).heal(10, 0, 2.4)


func test_heal_no_health() -> void:
	hurt_box.health = null
	
	await assert_error(func(): hurt_box.heal(10))\
			.is_push_error("%s is missing a 'Health' component" % hurt_box)
	
	verify_no_interactions(mock_health)


func test_heal_modifier_zero() -> void:
	hurt_box.heal_multiplier = 0.0
	hurt_box.heal(10)
	
	verify_no_interactions(mock_health)


func test_heal_negative_modifier() -> void:
	hurt_box.heal_multiplier = -1.0
	hurt_box.heal(10)
	
	verify(mock_health, 1).heal(10, 0, -1.0)


func test_damage_on_heal() -> void:
	hurt_box.damage_on_heal = true
	hurt_box.heal(10)
	
	verify(mock_health, 1).damage(10)
