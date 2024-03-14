extends Node2D

@export var pop_sfx: Resource
@export var is_consumed := true

signal play_effect

func _ready():
	get_parent().effect = bag_pop
	get_parent().effect_node = self

func bag_pop(player):
	if pop_sfx:
		player.play_sound(pop_sfx)
	play_effect.emit()
	return is_consumed
