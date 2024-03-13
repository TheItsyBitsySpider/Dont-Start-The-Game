extends Node2D

@export var lighting_effect: PackedScene

var on := true
var lighting_instance = null

signal play_effect

func _ready():
	get_parent().effect = light_switch_effect
	get_parent().effect_node = self
	lighting_instance = lighting_effect.instantiate()

func light_switch_effect(_player):
	on = not on
	if not on:
		get_tree().get_root().add_child(lighting_instance)
	else:
		get_tree().get_root().remove_child(lighting_instance)
	play_effect.emit()
	return false

func on_level_exit():
	if lighting_instance in get_tree().get_root().get_children():
		get_tree().get_root().remove_child(lighting_instance)
