extends Node2D

@export var rule_text: String
@export var target_action: String

var rule_completed := false

signal complete_rule

func _unhandled_input(event):
	if rule_completed \
	or get_parent().get_parent().level_elevator.has_control:
		return
	if event.is_action_pressed(target_action):
		rule_completed = true
		complete_rule.emit()
