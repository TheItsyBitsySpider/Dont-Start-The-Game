extends Node2D


var inventory
var player
var currentLevel
var ruleList

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $MainCharacter
	inventory = $CanvasLayer/InventoryManager
	currentLevel = $TileMap
	ruleList = $CanvasLayer/RuleBox/RuleLister
	player.MAX_INVENTORY = inventory.get_child_count()
	
	player.addToInventory.connect(inventory.addItemToInventory)
	player.removeFromInventory.connect(inventory.removeItemFromInventory)
	player.updatedHighlightedItem.connect(inventory.updateHighlightedItem)
	
	updateRules()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateRules():
	var allRules = currentLevel.ruleManager.get_children()
	var allRuleText = ""
	for rule in allRules:
		if not rule.ruleCompleted.is_connected(updateRules):
			rule.ruleCompleted.connect(updateRules)
		if rule.completed:
			allRuleText += "[s]"
			allRuleText += rule.ruleText
			allRuleText += "[/s]"
		else:
			allRuleText += rule.ruleText
		allRuleText += "\n"
	ruleList.set_text(allRuleText)
