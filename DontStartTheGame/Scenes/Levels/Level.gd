extends TileMap

@onready var rule_manager = $Rules

signal on_item_picked_up

func _on_main_character_add_to_inventory(_item):
	on_item_picked_up.emit();
