extends Sprite2D

@export var weight := 10
@export var floatiness := 1.0
@export var post_consume_item: PackedScene

@onready var popup_node := $Popup
@onready var collision_layer = $Area2D.collision_layer
@onready var scene_ID := scene_file_path

var player = null

var effect
var effect_node
var velocity := Vector2.ZERO

signal play_effect
signal on_item_thrown

func _physics_process(delta):
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, 750.0 * delta * floatiness)

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		player = body
		player.nearby_items.append(self)
		popup_node.visible = true
	else:
		velocity = velocity.bounce(velocity.normalized()) / 2

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		player.nearby_items.erase(self)
		player = null
		popup_node.visible = false

func _on_effect_effect_played():
	play_effect.emit()

func throw(throw_speed: Vector2):
	velocity += throw_speed
	on_item_thrown.emit(self)

func give_signal_connections_to(item):
	var play_effect_connections = play_effect.get_connections()
	var on_item_thrown_connections = on_item_thrown.get_connections()
	for connection in play_effect_connections:
		item.play_effect.connect(connection["callable"])
	for connection in on_item_thrown_connections:
		item.on_item_thrown.connect(connection["callable"])
