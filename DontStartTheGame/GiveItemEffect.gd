extends Node2D

@export var item_to_give: PackedScene
@export var required_item: PackedScene

signal play_effect

func _ready():
	get_parent().effect = give_item_effect
	get_parent().effect_node = self
	
func give_item_effect(player):
	if item_to_give == null:
		return
	if required_item != null and player.item_held != null and player.item_held.scene_file_path == required_item.resource_path:
		var item_instance = item_to_give.instantiate()
		add_child(item_instance)
		player.item_held.give_signal_connections_to(item_instance)
		player.remove_item_from_inventory(player.inventory_items.find(player.item_held))
		if not player.add_item_to_inventory(item_instance):
			item_instance.queue_free()
		play_effect.emit()
	elif required_item == null:
		var item_instance = item_to_give.instantiate()
		add_child(item_instance)
		if not player.add_item_to_inventory(item_instance):
			item_instance.queue_free()
		play_effect.emit()
	return false
