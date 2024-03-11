extends CharacterBody2D

@export var SPEED: int
@export var current_level: Node
@onready var sprite := $Sprite2D

const MAX_INVENTORY := 4

var nearby_items := []
var nearby_interactables := []
var inventory_items := []
var selected_inventory_slot := 0

enum Directions { UP, DOWN, LEFT, RIGHT }
var direction_facing := Directions.DOWN

signal add_to_inventory
signal remove_from_inventory
signal change_selected_inventory_slot
signal consume_item

func _ready():
	sprite.flip_h = 1

func _physics_process(_delta):
	# Controls movement
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	velocity = Vector2(direction_x * SPEED, direction_y * SPEED)
	move_and_slide()
	
	# Determines direction facing
	if Input.is_action_just_pressed("move_up") and not Input.is_action_just_pressed("move_down"):
		direction_facing = Directions.UP
	if Input.is_action_just_pressed("move_down"):
		direction_facing = Directions.DOWN
	if Input.is_action_just_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		direction_facing = Directions.LEFT
	if Input.is_action_just_pressed("move_right"):
		direction_facing = Directions.RIGHT
	
	# Transforms sprite according to direction facing
	if direction_facing == Directions.LEFT:
		sprite.flip_h = 0
	elif direction_facing == Directions.RIGHT:
		sprite.flip_h = 1
	
	# Determines whether a nearby item could be picked up
	var interactable_item = null
	for nearby_item in nearby_items:
		if nearby_item.velocity == Vector2.ZERO:
			interactable_item = nearby_item
			break
	
	# Picks up nearby item
	if Input.is_action_just_pressed("interact") and interactable_item != null:
		add_item_to_inventory(interactable_item)
	
	# Interacts with an object
	elif Input.is_action_just_pressed("interact") and not nearby_interactables.is_empty():
		interact_with_object(nearby_interactables.front())
	
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
	
	# Determines whether an inventory item is selected
	var selected_item = null
	if selected_inventory_slot < len(inventory_items) and inventory_items[selected_inventory_slot] != null:
		selected_item = inventory_items[selected_inventory_slot]
	
	# Uses selected item
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and selected_item != null:
		consume_item.emit(selected_item.effect)
		var is_consumable = selected_item.effect.call(self)
		if is_consumable:
			inventory_items[selected_inventory_slot] = null
			remove_from_inventory.emit(selected_inventory_slot)
	
	# Throws selected item
	if Input.is_physical_key_pressed(KEY_SPACE) and selected_item != null and current_level != null:
		inventory_items[selected_inventory_slot] = null
		remove_from_inventory.emit(selected_inventory_slot)
		selected_item.position = position
		var throw_speed = 5000.0 / selected_item.weight
		if direction_facing == Directions.UP:
			selected_item.throw(Vector2(0.0, -throw_speed))
		elif direction_facing == Directions.DOWN:
			selected_item.throw(Vector2(0.0, throw_speed))
		elif direction_facing == Directions.LEFT:
			selected_item.throw(Vector2(-throw_speed, 0.0))
		else:
			selected_item.throw(Vector2(throw_speed, 0.0))
		current_level.add_child(selected_item)

func _change_selected_inventory_slot(i: int):
	if i < 0 or i >= MAX_INVENTORY:
		return
	selected_inventory_slot = i
	change_selected_inventory_slot.emit(i)

func play_sound(sound_resource):
	$SFX.set_stream(sound_resource)
	$SFX.play()

func add_item_to_inventory(item):
	if null in inventory_items:
		nearby_items.erase(item)
		inventory_items[inventory_items.find(null)] = item
		add_to_inventory.emit(item)
		item.get_parent().remove_child(item)
	elif len(inventory_items) < MAX_INVENTORY:
		nearby_items.erase(item)
		inventory_items.append(item)
		add_to_inventory.emit(item)
		item.get_parent().remove_child(item)

func interact_with_object(interactable):
		var is_consumable = interactable.effect.call(self)
		if is_consumable:
			interactable.queue_free()
