extends CharacterBody2D

@export var SPEED: int
@export var current_level: Node
@export var description_text: RichTextLabel
@export var shout_sfx_1: Resource
@export var shout_sfx_2: Resource
@export var shout_sfx_3: Resource
@export var shout_sfx_4: Resource
@onready var sprite := $Sprite2D
@onready var shadow = $Shadow
@onready var animation_player := $AnimationPlayer
@onready var sfx := $SFX

const MAX_INVENTORY := 4

var rng := RandomNumberGenerator.new()

var nearby_items := []
var nearby_interactables := []
var nearby_objects_with_descriptions := []
var inventory_items := []
var selected_inventory_slot := 0
var item_held = null

enum Directions { UP, DOWN, LEFT, RIGHT }
var direction_facing := Directions.DOWN

signal add_to_inventory
signal remove_from_inventory
signal change_selected_inventory_slot
signal consume_item
signal shouted

func _ready():
	animation_player.play("idle_front_right")

func _physics_process(_delta):
	# Controls movement
	var player_moved = false
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	player_moved = velocity != Vector2.ZERO
	move_and_slide()
	
	if player_moved and description_text.text != "":
		description_text.get_parent().visible = false
		description_text.text = ""
	
	# Controls animation
	if player_moved and animation_player.current_animation != "walk_front_right":
		animation_player.play("walk_front_right")
	elif not player_moved and animation_player.current_animation != "idle_front_right":
		animation_player.play("idle_front_right")
	
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
		sprite.flip_h = 1
		shadow.flip_h = 1
	elif direction_facing == Directions.RIGHT:
		sprite.flip_h = 0
		shadow.flip_h = 0
	
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
	
	# Gets the description of a non-interactable object
	elif Input.is_action_just_pressed("interact") and not nearby_objects_with_descriptions.is_empty():
		get_description(nearby_objects_with_descriptions.front())
	
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
	if Input.is_action_just_pressed("use") and selected_item != null:
		use_item(selected_item)

	# Throws selected item
	if Input.is_physical_key_pressed(KEY_SPACE) and selected_item != null and current_level != null:
		remove_item_from_inventory(selected_inventory_slot)
		selected_item.position = position
		var throw_speed = 5000.0 / selected_item.weight
		selected_item.throw(position.direction_to(get_global_mouse_position()) * throw_speed)
		current_level.add_child(selected_item)
		
	item_held = selected_item
	
	# Shouts
	if Input.is_action_just_pressed("shout"):
		var shout_sfx_list := [
			shout_sfx_1,
			shout_sfx_2,
			shout_sfx_3,
			shout_sfx_4
		]
		var i := rng.randi_range(0, len(shout_sfx_list) - 1)
		sfx.set_stream(shout_sfx_list[i])
		sfx.play()
		shouted.emit()

func _change_selected_inventory_slot(i: int):
	if i < 0 or i >= MAX_INVENTORY:
		return
	selected_inventory_slot = i
	change_selected_inventory_slot.emit(i)

func play_sound(sound_resource):
	sfx.set_stream(sound_resource)
	sfx.play()

func add_item_to_inventory(item):
	if null in inventory_items:
		nearby_items.erase(item)
		inventory_items[inventory_items.find(null)] = item
		add_to_inventory.emit(item)
		item.get_parent().remove_child(item)
		return true
	elif len(inventory_items) < MAX_INVENTORY:
		nearby_items.erase(item)
		inventory_items.append(item)
		add_to_inventory.emit(item)
		item.get_parent().remove_child(item)
		return true
	return false

func interact_with_object(interactable):
		var is_consumable = interactable.effect.call(self)
		if is_consumable:
			interactable.queue_free()

func use_item(selected_item):
	consume_item.emit(selected_item.effect)
	var is_consumable = selected_item.effect.call(self)
	if is_consumable:
		if selected_item.post_consume_item != null:
			var new_item_instance = selected_item.post_consume_item.instantiate()
			add_child(new_item_instance)
			selected_item.give_signal_connections_to(new_item_instance)
			remove_item_from_inventory(selected_inventory_slot)	
			if not add_item_to_inventory(new_item_instance):
				new_item_instance.queue_free()
		else:
			remove_item_from_inventory(selected_inventory_slot)	

func remove_item_from_inventory(index):
	inventory_items[index] = null
	remove_from_inventory.emit(index)

func get_description(selected_object):
	description_text.get_parent().visible = true
	description_text.text = selected_object.description
