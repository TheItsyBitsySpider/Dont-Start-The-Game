extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func addItemToInventory(item):
	var allInventorySlots = get_children()
	for slot in allInventorySlots:
		if slot.itemID == null:
			slot.addItem(item)
			return

func removeItemFromInventory(index):
	var allInventorySlots = get_children()
	for slotIndex in range(len(allInventorySlots)):
		if slotIndex == index:
			allInventorySlots[slotIndex].removeItem()

func updateHighlightedItem(highlight):
	
	for slot in get_children():
		slot.unmakeHighlighted()
	
	get_children()[highlight].makeHighlighted()

