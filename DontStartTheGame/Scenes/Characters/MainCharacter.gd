extends CharacterBody2D

@export var SPEED: int

var MAX_INVENTORY
var nearbyItems = []
var inventory = []
var highlighted = 0

signal addToInventory
signal removeFromInventory
signal updatedHighlightedItem
signal usedItem

func _physics_process(delta):

	var directionX = Input.get_axis("moveLeft", "moveRight")
	var directionY = Input.get_axis("moveUp", "moveDown")
	
	velocity = Vector2(directionX*SPEED, directionY*SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("Interact") and not nearbyItems.is_empty():
		var itemToPickup
		
		if null in inventory:
			itemToPickup = nearbyItems.pop_front()
			inventory[inventory.find(null)] = itemToPickup.effect
			addToInventory.emit(itemToPickup)
		
		
		elif len(inventory) < MAX_INVENTORY:
			itemToPickup = nearbyItems.pop_front()
			inventory.append(itemToPickup.effect)
			addToInventory.emit(itemToPickup)

		else:
			# If inventory slots are full, don't do anything
			return
		
		itemToPickup.get_parent().remove_child(itemToPickup)
	
	if Input.is_action_just_released("MWU"):
		if highlighted < MAX_INVENTORY-1:
			highlighted += 1
		else:
			highlighted = 0
		updatedHighlightedItem.emit(highlighted)
	
	if Input.is_action_just_released("MWD"):
		if highlighted > 0:
			highlighted -= 1
		else:
			highlighted = MAX_INVENTORY-1
		updatedHighlightedItem.emit(highlighted)
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print("Attempting to use item: " + str(highlighted))
		if  highlighted >= len(inventory):
			return
		if inventory.is_empty() or inventory[highlighted] == null:
			return
		var isConsumable = inventory[highlighted].call(self)
		usedItem.emit(inventory[highlighted])
		if isConsumable:
			inventory[highlighted] = null
			removeFromInventory.emit(highlighted)
		#print(inventory)
			
func playSound(resource):
	$SFX.set_stream(resource)
	$SFX.play()
