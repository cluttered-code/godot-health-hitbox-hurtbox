class_name HealthActionType extends Object

## These are the keys used to add [HealthModifier] to [Health] and HurtBoxes.
## NOTICE: Developers can add health action types here to enable more modifiers.
## ALERT: It is recommended to move this and it's guid file out of the 'addon' folder
## when adding more customs types so this file isn't replaced when updating the plugin.[br]
## [br]
## examples of other damage types: BLUDGEON, PIERCE, POISON, FIRE, LIGHTNING...
## examples of other heal types: POTION, MED_KIT, INJECTION, FOOD...
enum Enum { NONE, MEDICINE, KINETIC }
