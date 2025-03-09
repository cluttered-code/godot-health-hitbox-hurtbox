class_name Enemy extends CharacterBody2D

@onready var health: Health = $Health
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	health.action_applied.connect(_on_health_action_applied)
	health.died.connect(_on_died)


func _process(delta: float) -> void:
	if transform.x.x < 0:
		progress_bar.fill_mode = progress_bar.FILL_END_TO_BEGIN
	else:
		progress_bar.fill_mode = progress_bar.FILL_BEGIN_TO_END


func _on_died(_entity: Node) -> void:
	health.fill_health()


func _on_health_action_applied(_entity: Node, _affect: Health.Affect, _type: HealthActionType.Enum, _amount: int, _applied: int, _incrementer: int, _multiplier: float) -> void:
	_update_progress_bar()


func _update_progress_bar() -> void:
	progress_bar.value = health.percent()
