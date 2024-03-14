extends Node2D

@export var required_item: PackedScene
@export var item_to_give: PackedScene
@export var opened_safe_sprite: Resource
@export var sprite_to_change: Sprite2D
var unopened := true

signal play_effect

func _ready():
	get_parent().effect = give_item_effect
	get_parent().effect_node = self
	
func give_item_effect(player):
	if required_item != null \
	and player.item_held != null \
	and player.item_held.scene_file_path == required_item.resource_path \
	and unopened:
		var item_instance = item_to_give.instantiate()
		add_child(item_instance)
		player.item_held.give_signal_connections_to(item_instance)
		player.remove_item_from_inventory(player.inventory_items.find(player.item_held))
		if not player.add_item_to_inventory(item_instance):
			item_instance.queue_free()
		play_effect.emit()
		unopened = false
		sprite_to_change.texture = opened_safe_sprite
	return false
