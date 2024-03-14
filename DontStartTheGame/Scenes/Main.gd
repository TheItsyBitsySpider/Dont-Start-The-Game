extends Node2D

@export var starting_level: PackedScene
@onready var player := $MainCharacter
@onready var current_level = null
@onready var inventory_manager := $CanvasLayer/InventoryManager
@onready var rule_box := $CanvasLayer/RuleBox
@onready var rules_list := $CanvasLayer/RuleBox/RuleLister

func _ready():
	RenderingServer.set_default_clear_color(Color.hex(0x212123ff))
	player.add_to_inventory.connect(inventory_manager.add_item)
	player.remove_from_inventory.connect(inventory_manager.remove_item)
	player.change_selected_inventory_slot.connect(inventory_manager.change_selected)
	inventory_manager.change_selected(0)
	load_level(starting_level)

func update_rules():
	var rules = current_level.rule_manager.get_children()
	var rules_text = ""
	var rule_completion_count = 0
	for rule in rules:
		if not rule.complete_rule.is_connected(update_rules):
			rule.complete_rule.connect(update_rules)
		if rule.rule_completed:
			rule_completion_count += 1
			rules_text += "[s]" + rule.rule_text + "[/s]"
		else:
			rules_text += rule.rule_text
		rules_text += "\n"
	rules_list.set_text(rules_text)
	if rule_completion_count >= len(rules):
		current_level.unlock_elevator()

func load_level(level):
	get_tree().call_group("Residuals", "on_level_exit")
	call_deferred("load_level_helper", level)

func load_level_helper(level):
	if current_level != null:
		current_level.queue_free()
	current_level = level.instantiate()
	player.current_level = current_level
	add_child(current_level)
	if current_level.name == "EndingScreen":
		set_gui_visibility(false)
		remove_child(player)
		return
	player.position = current_level.get_spawnpoint()
	update_rules()
	update_connections()

func update_connections():
	player.add_to_inventory.connect(current_level._on_main_character_add_to_inventory)

func set_gui_visibility(visibility: bool):
	for inventory_slot in inventory_manager.get_children():
		inventory_slot.visible = visibility
	rule_box.visible = visibility
	rules_list.visible = visibility
