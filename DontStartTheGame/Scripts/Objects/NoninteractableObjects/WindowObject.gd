extends StaticBody2D

@export var description := "None of the rules say defenestration isn’t allowed."
@export var broken_window_sprite: Resource
@export var duck_in_level: Sprite2D
@onready var window_sfx := $SFX
@onready var window_sprite := $Sprite2D

var player = null
var effect
var effect_node
var effect_happened := false
var saved_item_position

signal play_effect

# Centers window on tile so it fits neatly with the walls
func _ready():
	position = get_parent().map_to_local(get_parent().local_to_map(position))
	if duck_in_level != null:
		saved_item_position = duck_in_level.position

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer == 6:
		play_effect.emit(body.get_parent())
		window_sfx.play()
		window_sprite.texture = broken_window_sprite
		if body.get_parent() == duck_in_level:
			# Can add a message chastising player later
			duck_in_level.velocity = Vector2.ZERO
			duck_in_level.position = saved_item_position
		else:
			body.get_parent().get_parent().remove_child(body.get_parent())
	elif body.collision_layer == 5:
		player = body
		player.nearby_objects_with_descriptions.append(self)

func _on_interact_area_body_exited(_body):
	if player != null:
		player.nearby_objects_with_descriptions.erase(self)
		player = null
