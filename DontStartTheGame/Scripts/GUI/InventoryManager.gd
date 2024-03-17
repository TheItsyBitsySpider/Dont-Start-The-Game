extends Control

func add_item(item):
	var inventory_slots = get_children()
	for inventory_slot in inventory_slots:
		if inventory_slot.item_ID == null:
			inventory_slot.add_item(item)
			if inventory_slot.texture == inventory_slot.sprite_selected:
				inventory_slot.show_description()
			return

func remove_item(i):
	var inventory_slots = get_children()
	if i >= 0 and i < len(inventory_slots):
		inventory_slots[i].remove_item()
		if inventory_slots[i].texture == inventory_slots[i].sprite_selected:
			inventory_slots[i].hide_description()

func change_selected(i):
	var inventory_slots = get_children()
	if i < 0 or i >= len(inventory_slots):
		return
	for inventory_slot in inventory_slots:
		inventory_slot.unhighlight()
	inventory_slots[i].highlight()
