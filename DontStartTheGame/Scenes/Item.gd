extends Sprite2D

@export var weight := 10

@onready var popup_node := $Popup
@onready var scene_ID := scene_file_path

var player = null

var effect
var effect_node

var velocity := Vector2.ZERO

signal play_effect

func _physics_process(delta):
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, 750.0 * delta)

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
