extends Node2D

signal play_effect

func _ready():
	get_parent().effect = do_nothing
	get_parent().effect_node = self

func do_nothing(_player):
	return false
