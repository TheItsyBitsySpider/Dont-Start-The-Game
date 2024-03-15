extends Node2D

@export var required_item: PackedScene
var overwatered := false

signal play_effect
signal overwater

func _ready():
	get_parent().effect = water_plant
	get_parent().effect_node = self

func water_plant(player):
	if required_item != null \
	and player.item_held != null \
	and player.item_held.scene_file_path == required_item.resource_path:
		player.use_item(player.item_held)
		if not overwatered:
			overwater.emit()
		else:
			play_effect.emit()
		overwatered = true
