extends StaticBody2D

@onready var window_sfx := $SFX

var player = null
var effect
var effect_node
var effect_happened := false

signal play_effect

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer == 6:
		play_effect.emit(body.get_parent())
		window_sfx.play()
		body.get_parent().get_parent().remove_child(body.get_parent())
	else:
		player = body

func _on_interact_area_body_exited(_body):
	player = null
