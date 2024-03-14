extends Node2D

@export var spill_sfx: Resource

signal play_effect

func _ready():
	get_parent().effect = spill
	get_parent().effect_node = self

func spill(player):
	if spill_sfx:
		player.play_sound(spill_sfx)
	play_effect.emit()
	return true
