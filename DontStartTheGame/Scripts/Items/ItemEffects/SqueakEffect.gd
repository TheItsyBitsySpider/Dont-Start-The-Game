extends Node2D

@export var squeak_sfx: Resource

signal play_effect

func _ready():
	get_parent().effect = squeak
	get_parent().effect_node = self

func squeak(player):
	var sfx := AudioStreamPlayer.new()
	player.add_child(sfx)
	sfx.set_stream(squeak_sfx)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)
	play_effect.emit()
	return false
