extends Node2D

@export var item_to_give: PackedScene

signal play_effect

func _ready():
	get_parent().effect = give_item_effect
	get_parent().effect_node = self

func give_item_effect(player):
	if item_to_give == null:
		return
	var item_instance = item_to_give.instantiate()
	add_child(item_instance)
	if not player.add_item_to_inventory(item_instance):
		item_instance.queue_free()
	return false
