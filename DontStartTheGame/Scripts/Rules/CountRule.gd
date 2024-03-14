extends Node2D

@export var rule_text: String
@export var target: int

var rule_completed := false
var count := 0

signal complete_rule

func increment_count(_obj = null):
	if rule_completed == true:
		return
	count += 1
	if count >= target:
		rule_completed = true
		complete_rule.emit()
