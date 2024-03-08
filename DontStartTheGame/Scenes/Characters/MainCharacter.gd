extends CharacterBody2D

@export var SPEED: int

var nearbyItems = []
var leftSlot = null
var rightSlot = null

signal pickedUpLeftObject
signal pickedUpRightObject

func _physics_process(delta):

	var directionX = Input.get_axis("moveLeft", "moveRight")
	var directionY = Input.get_axis("moveUp", "moveDown")
	
	velocity = Vector2(directionX*SPEED, directionY*SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("Interact") and not nearbyItems.is_empty():
		var itemToPickup
		if leftSlot == null:
			itemToPickup = nearbyItems.pop_front()
			pickedUpLeftObject.emit(itemToPickup)
			leftSlot = itemToPickup.sceneID
		elif rightSlot == null:
			itemToPickup = nearbyItems.pop_front()
			pickedUpRightObject.emit(itemToPickup)
			rightSlot = itemToPickup.sceneID
		else:
			# If both inventory slots are full, don't do anything
			return
		
		itemToPickup.queue_free()
		pass
