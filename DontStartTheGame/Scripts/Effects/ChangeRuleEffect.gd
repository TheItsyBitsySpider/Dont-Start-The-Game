extends Node2D

@export var required_item: PackedScene

var unwritten := true

signal play_effect

func _ready():
	get_parent().effect = give_item_effect
	get_parent().effect_node = self
	
func give_item_effect(player):
	if required_item != null \
	and player.item_held != null \
	and player.item_held.scene_file_path == required_item.resource_path \
	and unwritten:
		play_effect.emit()
		required_item = null
		unwritten = false
	return false
