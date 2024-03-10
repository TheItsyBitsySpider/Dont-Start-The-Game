extends TileMap

@onready var rule_manager = $Rules
@onready var level_elevator = $Elevator
@onready var spawnpoint := $Spawnpoint
@export var next_level := PackedScene

signal on_item_picked_up

func _on_main_character_add_to_inventory(_item):
	on_item_picked_up.emit();

func unlock_elevator():
	level_elevator.unlock_elevator()

func change_level(player):
	get_parent().load_level(next_level)

func get_spawnpoint():
	return spawnpoint.position
