extends Control

func _ready():
	pass

func _process(_delta):
	pass

func add_item(item):
	var inventory_slots = get_children()
	for inventory_slot in inventory_slots:
		if inventory_slot.item_ID == null:
			inventory_slot.add_item(item)
			return

func remove_item(i):
	var inventory_slots = get_children()
	if i >= 0 and i < len(inventory_slots):
		inventory_slots[i].remove_item()

func change_selected(i):
	var inventory_slots = get_children()
	if i < 0 or i >= len(inventory_slots):
		return
	for inventory_slot in inventory_slots:
		inventory_slot.unhighlight()
	inventory_slots[i].highlight()
