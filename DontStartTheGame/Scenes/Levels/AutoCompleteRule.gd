extends Node2D

@export var rule_text: String

var rule_completed := true

signal complete_rule

func _ready():
	complete_rule.emit()
