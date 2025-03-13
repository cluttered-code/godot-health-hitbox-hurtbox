class_name HealthTest extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const test_character_scene: PackedScene = preload("res://test/scenes/test_character.tscn")

const SIG_DAMAGED := "damaged"
const SIG_DIED := "died"
const SIG_HEALED := "healed"
const SIG_REVIVED := "revived"
const SIG_ACTION_APPLIED := "action_applied"
const SIG_FIRST_HIT := "first_hit"
const SIG_NOT_DAMAGEABLE := "not_damageable"
const SIG_ALREADY_DEAD := "already_dead"
const SIG_NOT_KILLABLE := "not_killable"
const SIG_NOT_HEALABLE := "not_healable"
const SIG_FULL := "full"
const SIG_ALREADY_FULL := "already_full"
const SIG_NOT_REVIVABLE := "not_revivable"

var test_character: CharacterBody2D
var health: Health
var signals: Object


func before_test() -> void:
	test_character = auto_free(test_character_scene.instantiate())
	add_child(test_character)
	
	health = test_character.health
	signals = monitor_signals(health)


func test_current_default() -> void:
	assert_int(health.current).is_equal(Health.DEFAULT_MAX)


func test_current_42() -> void:
	health.current = 42
	assert_int(health.current).is_equal(42)


func test_current_0() -> void:
	health.current = 0
	assert_int(health.current).is_equal(0)


func test_current_negative() -> void:
	health.current = -25
	assert_int(health.current).is_equal(0)


func test_current_max() -> void:
	health.current = health.max
	assert_int(health.current).is_equal(health.max)


func test_current_gt_max() -> void:
	health.current = health.max + 1
	assert_int(health.current).is_equal(health.max)


func test_max_default() -> void:
	assert_int(health.max).is_equal(Health.DEFAULT_MAX)


func test_max_raise() -> void:
	health.max += 1
	assert_int(health.max).is_equal(Health.DEFAULT_MAX + 1)


func test_max_1() -> void:
	health.max = 1
	assert_int(health.max).is_equal(1)


func test_max_0() -> void:
	health.max = 0
	assert_int(health.max).is_equal(1)


func test_max_negative() -> void:
	health.max = -25
	assert_int(health.max).is_equal(1)


func test_max_reduces_current() -> void:
	health.max = 42
	assert_int(health.current).is_equal(42)
	assert_int(health.max).is_equal(42)


func test_is_dead_default() -> void:
	assert_bool(health.is_dead()).is_false()


func test_is_dead_true() -> void:
	health.current = 0
	assert_bool(health.is_dead()).is_true()


func test_is_dead_not_killable() -> void:
	health.killable = false
	health.current = 0
	assert_bool(health.is_dead()).is_false()


func test_is_alive_default() -> void:
	assert_bool(health.is_alive()).is_true()


func test_is_alive_false() -> void:
	health.current = 0
	assert_bool(health.is_alive()).is_false()


func test_is_alive_not_killable() -> void:
	health.killable = false
	health.current = 0
	assert_bool(health.is_alive()).is_true()


func test_is_full_default() -> void:
	assert_bool(health.is_full()).is_true()


func test_percent_full() -> void:
	assert_float(health.percent()).is_equal(1.0)


func test_is_full_false() -> void:
	health.current -= 1
	assert_bool(health.is_full()).is_false()


func test_percent_half() -> void:
	health.current /= 2
	assert_float(health.percent()).is_equal(0.5)


func test_percent_0() -> void:
	health.current = 0
	assert_float(health.percent()).is_equal(0.0)


func test_percent_decimal() -> void:
	health.current = 1
	health.max = 3
	assert_float(health.percent()).is_equal_approx(0.333333, 0.000001)


func test_damage() -> void:
	health.current -= 10
	health.damage(20)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX - 30)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, 20, 0, 1.0, 20])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 20])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_apply_action() -> void:
	health.current -= 10
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 15)
	
	health.apply_action(action)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX - 25)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.KINETIC, 15, 0, 1.0, 15])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 15])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_apply_modified_action() -> void:
	health.current -= 10
	
	var action := HealthAction.new(Health.Affect.DAMAGE, HealthActionType.Enum.KINETIC, 4)
	var modifier := HealthModifier.new(1, 2.0)
	var modified_action := HealthModifiedAction.new(action, modifier)
	
	health.apply_modified_action(modified_action)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX - 20)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.KINETIC, 4, 1, 2.0, 10])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 10])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_first_hit() -> void:
	health.damage(42)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX - 42)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, 42, 0, 1.0, 42])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 42])
	await assert_signal(signals).is_emitted(SIG_FIRST_HIT, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_death() -> void:
	health.current -= 10
	health.damage(Health.DEFAULT_MAX)
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, Health.DEFAULT_MAX, 0, 1.0, 90])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 90])
	await assert_signal(signals).is_emitted(SIG_DIED, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_already_dead() -> void:
	health.current = 0
	health.damage(10)
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_ALREADY_DEAD, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DAMAGED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_one_shot() -> void:
	health.damage(Health.DEFAULT_MAX)
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, Health.DEFAULT_MAX, 0, 1.0, Health.DEFAULT_MAX])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), Health.DEFAULT_MAX])
	await assert_signal(signals).is_emitted(SIG_FIRST_HIT, [test_character])
	await assert_signal(signals).is_emitted(SIG_DIED, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_not_damageable() -> void:
	health.damageable = false
	health.damage(Health.DEFAULT_MAX)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX)
	
	await assert_signal(signals).is_emitted(SIG_NOT_DAMAGEABLE, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DAMAGED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_not_killable() -> void:
	health.killable = false
	health.damage(10)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX - 10)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, 10, 0, 1.0, 10])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 10])
	await assert_signal(signals).is_emitted(SIG_FIRST_HIT, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_damage_kill_not_killable() -> void:
	health.killable = false
	health.current = 10
	health.damage(10)
	assert_int(health.current).is_equal(10)
	
	await assert_signal(signals).is_emitted(SIG_NOT_KILLABLE, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DAMAGED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FIRST_HIT, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_DIED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])


func test_kill() -> void:
	health.kill()
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_DAMAGED, [test_character, HealthActionType.Enum.NONE, Health.DEFAULT_MAX, 0, 1.0, Health.DEFAULT_MAX])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), Health.DEFAULT_MAX])
	await assert_signal(signals).is_emitted(SIG_FIRST_HIT, [test_character])
	await assert_signal(signals).is_emitted(SIG_DIED, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_DEAD, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_DAMAGEABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_KILLABLE, [any()])


func test_heal() -> void:
	health.current = 1
	health.heal(10)
	assert_int(health.current).is_equal(11)
	
	await assert_signal(signals).is_emitted(SIG_HEALED, [test_character, HealthActionType.Enum.NONE, 10, 0, 1.0, 10])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 10])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_HEALABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_full() -> void:
	health.current -= 10
	health.heal(20)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX)
	
	await assert_signal(signals).is_emitted(SIG_HEALED, [test_character, HealthActionType.Enum.NONE, 20, 0, 1.0, 10])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 10])
	await assert_signal(signals).is_emitted(SIG_FULL, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_HEALABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_already_full() -> void:
	health.heal(10)
	assert_int(health.current).is_equal(Health.DEFAULT_MAX)
	
	await assert_signal(signals).is_emitted(SIG_ALREADY_FULL, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HEALED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_HEALABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_revive() -> void:
	health.current = 0
	health.heal(10)
	assert_int(health.current).is_equal(10)
	
	await assert_signal(signals).is_emitted(SIG_HEALED, [test_character, HealthActionType.Enum.NONE, 10, 0, 1.0, 10])
	await assert_signal(signals).is_emitted(SIG_ACTION_APPLIED, [any(), 10])
	await assert_signal(signals).is_emitted(SIG_REVIVED, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_HEALABLE, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_not_healable() -> void:
	health.healable = false
	health.current = 1
	health.heal(10)
	assert_int(health.current).is_equal(1)
	
	await assert_signal(signals).is_emitted(SIG_NOT_HEALABLE, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HEALED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ACTION_APPLIED, [any(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_not_healable_and_dead() -> void:
	health.healable = false
	health.current = 0
	health.heal(10)
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_NOT_HEALABLE, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HEALED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])


func test_heal_not_revivable() -> void:
	health.revivable = false
	health.current = 0
	health.heal(10)
	assert_int(health.current).is_equal(0)
	
	await assert_signal(signals).is_emitted(SIG_ALREADY_FULL, [test_character])
	
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_HEALED, [any(), any_int(), any_int(), any_int(), any_float(), any_int()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_REVIVED, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_ALREADY_FULL, [any()])
	await assert_signal(signals).wait_until(50).is_not_emitted(SIG_NOT_HEALABLE, [any()])
