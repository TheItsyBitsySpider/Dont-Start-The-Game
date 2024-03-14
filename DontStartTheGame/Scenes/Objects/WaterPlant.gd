extends Node2D

@export var required_item: PackedScene
@export var plant_sprite: Sprite2D

signal play_effect

func _ready():
	get_parent().effect = water_plant
	get_parent().effect_node = self
	
func water_plant(player):
	if required_item != null and player.item_held != null and player.item_held.scene_file_path == required_item.resource_path:
		player.use_item(player.item_held)
		plant_sprite.modulate = Color(0, 0, 255)
		play_effect.emit()
