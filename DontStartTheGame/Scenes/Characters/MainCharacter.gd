extends CharacterBody2D

@export var SPEED: int

const MAX_INVENTORY := 4

var nearby_items := []
var inventory_items := []
var selected_inventory_slot := 0

signal add_to_inventory
signal remove_from_inventory
signal change_selected_inventory_slot
signal consume_item

func _physics_process(_delta):
	# Controls movement
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	velocity = Vector2(direction_x * SPEED, direction_y * SPEED)
	move_and_slide()
	
	# Picks up nearby item
	if Input.is_action_just_pressed("interact") and not nearby_items.is_empty():
		if null in inventory_items:
			var item = nearby_items.pop_front()
			inventory_items[inventory_items.find(null)] = item.effect
			add_to_inventory.emit(item)
			item.get_parent().remove_child(item)
		elif len(inventory_items) < MAX_INVENTORY:
			var item = nearby_items.pop_front()
			inventory_items.append(item.effect)
			add_to_inventory.emit(item)
			item.get_parent().remove_child(item)
	
	# Traverses inventory using number keys
	for i in min(MAX_INVENTORY, 10):
		if Input.is_physical_key_pressed((KEY_1 + i) % (KEY_9 + 1)):
			_change_selected_inventory_slot(i)
	
	# Traverses inventory using mouse wheel
	if Input.is_action_just_released("mwu"):
		_change_selected_inventory_slot((selected_inventory_slot + 1) % MAX_INVENTORY)
	if Input.is_action_just_released("mwd"):
		if selected_inventory_slot == 0:
			_change_selected_inventory_slot(MAX_INVENTORY - 1)
		else:
			_change_selected_inventory_slot(selected_inventory_slot - 1)
	
	# Uses selected item
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# print("Attempting to use item at index: " + str(selected_inventory_slot))
		if selected_inventory_slot >= len(inventory_items):
			return
		if inventory_items[selected_inventory_slot] == null:
			return
		consume_item.emit(inventory_items[selected_inventory_slot])
		var is_consumable = inventory_items[selected_inventory_slot].call(self)
		if is_consumable:
			inventory_items[selected_inventory_slot] = null
			remove_from_inventory.emit(selected_inventory_slot)
		# print(inventory)

func _change_selected_inventory_slot(i: int):
	if i < 0 or i >= MAX_INVENTORY:
		return
	selected_inventory_slot = i
	change_selected_inventory_slot.emit(i)

func play_sound(sound_resource):
	$SFX.set_stream(sound_resource)
	$SFX.play()
