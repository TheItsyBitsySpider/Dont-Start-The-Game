extends Node2D

@export var eat_sfx: Resource

signal play_effect

func _ready():
	get_parent().effect = play_eat_sfx
	get_parent().effect_node = self

func _process(_delta):
	pass

func play_eat_sfx(player):
	if eat_sfx:
		player.play_sound(eat_sfx)
	play_effect.emit()
	return true
