extends StaticBody2D

@export var required_item: PackedScene
var popped = false

signal play_effect

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body is Area2D:
		body = body.get_parent()
	if body.collision_layer == 6 and not popped:
		play_effect.emit()
		$SFX.play()
		visible = false
		popped = true
