extends Node2D

@export var item_path: String

signal update_rule

func _ready():
	pass

func _process(_delta):
	pass

func on_item_used():
	update_rule.emit(1)
