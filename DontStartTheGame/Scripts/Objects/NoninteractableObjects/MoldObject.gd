extends StaticBody2D

@export var description := "Dark gray spots. It’s mold. It’s been here longer than you have. You think it’s broken."

var player = null
var effect
var effect_node
var effect_happened := false

signal play_effect

func _on_interact_area_body_entered(body):
	player = body
	player.nearby_objects_with_descriptions.append(self)

func _on_interact_area_body_exited(_body):
	player.nearby_objects_with_descriptions.erase(self)
	player = null
