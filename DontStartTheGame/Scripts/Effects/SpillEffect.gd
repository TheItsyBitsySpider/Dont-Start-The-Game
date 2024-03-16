extends Node2D

@export var spill_sfx: Resource

signal play_effect

func _ready():
	get_parent().effect = spill
	get_parent().effect_with_sfx = spill_with_sfx
	get_parent().effect_node = self

func spill(_player):
	play_effect.emit()
	return true

func spill_with_sfx(player):
	if spill_sfx:
		player.play_sound(spill_sfx)
	return spill(player)
