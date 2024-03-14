extends Node2D

@export var eat_sfx: Resource
@export var is_consumed := true

signal play_effect

func _ready():
	get_parent().effect = play_eat_sfx
	get_parent().effect_node = self

func play_eat_sfx(player):
	if eat_sfx:
		player.play_sound(eat_sfx)
	play_effect.emit()
	return is_consumed
