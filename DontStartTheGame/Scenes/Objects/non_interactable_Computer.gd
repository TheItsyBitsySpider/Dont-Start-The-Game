extends StaticBody2D

@export var required_item: PackedScene
var player = null
var effect
var effect_node
var effect_happened := false

signal play_effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if player != null and not effect_happened:
		if required_item != null and player.item_held != null and player.item_held.scene_file_path == required_item.resource_path:
			play_effect.emit()
			effect_happened = true

func _on_interact_area_body_entered(body):
	player = body


func _on_interact_area_body_exited(_body):
	player = null


func _on_item_detection():
	play_effect.emit()
