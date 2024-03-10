extends Node2D

@onready var player := $MainCharacter
@onready var current_level := $TileMap
@onready var inventory_manager := $CanvasLayer/InventoryManager
@onready var rules_list := $CanvasLayer/RuleBox/RuleLister

func _ready():
	player.add_to_inventory.connect(inventory_manager.add_item)
	player.remove_from_inventory.connect(inventory_manager.remove_item)
	player.change_selected_inventory_slot.connect(inventory_manager.change_selected)
	update_rules()

func _process(_delta):
	pass

func update_rules():
	var rules = current_level.rule_manager.get_children()
	var rules_text = ""
	for rule in rules:
		if not rule.complete_rule.is_connected(update_rules):
			rule.complete_rule.connect(update_rules)
		if rule.rule_completed:
			rules_text += "[s]" + rule.rule_text + "[/s]"
		else:
			rules_text += rule.rule_text
		rules_text += "\n"
	rules_list.set_text(rules_text)
