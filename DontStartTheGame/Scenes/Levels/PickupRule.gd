extends Node2D

@export var rule_text: String
@export var target: int
@export var target_item: PackedScene

var rule_completed := false
var count := 0

signal complete_rule

func increment_count_item(item):
	if rule_completed == true:
		return
	if item.scene_file_path != target_item.resource_path:
		return
	count += 1
	if count >= target:
		rule_completed = true
		complete_rule.emit()
