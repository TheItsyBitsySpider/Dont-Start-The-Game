extends Node2D

@export var starting_level: PackedScene
@onready var player := $PlayerCharacter
@onready var current_level = null
@onready var inventory_manager := $CanvasLayer/InventoryManager
@onready var rule_box := $CanvasLayer/RuleBox
@onready var rules_label := $CanvasLayer/RuleBox/RuleListerLabel
@onready var rules_list := $CanvasLayer/RuleBox/RuleLister

func _ready():
	RenderingServer.set_default_clear_color(Color.hex(0x212123ff))
	get_tree().get_root().size_changed.connect(resize)
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

func resize():
	if get_viewport_rect().size.x >= 1600:
		rule_box.position = Vector2(32, 32)
		rule_box.size = Vector2(624, 272)
		rules_label.set("theme_override_font_sizes/font_size", 40)
		rules_list.position = Vector2(40, 54)
		rules_list.size = Vector2(560, 202)
		rules_list.set("theme_override_font_sizes/normal_font_size", 32)
		rules_list.set("theme_override_constants/line_separation", -12)
	else:
		rule_box.position = Vector2(16, 16)
		rule_box.size = Vector2(464, 208)
		rules_label.set("theme_override_font_sizes/font_size", 32)
		rules_list.position = Vector2(32, 46)
		rules_list.size = Vector2(408, 146)
		rules_list.set("theme_override_font_sizes/normal_font_size", 24)
		rules_list.set("theme_override_constants/line_separation", -10)