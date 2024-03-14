extends StaticBody2D

@export var required_item: PackedScene

var player = null
var effect
var effect_node
var effect_happened := false

signal is_mad
signal play_effect

func _process(_delta):
	if player != null \
	and not effect_happened \
	and required_item != null \
	and player.item_held != null \
	and player.item_held.scene_file_path == required_item.resource_path:
		play_effect.emit()
		effect_happened = true

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body is Area2D:
		body = body.get_parent()
	if body.collision_layer == 6 \
	and body.scene_file_path == required_item.resource_path:
		play_effect.emit()
	elif body.collision_layer == 5:
		player = body
		player.shouted.connect(anger)

func _on_interact_area_body_exited(_body):
	if player != null:
		player.shouted.disconnect(anger)
		player = null

func anger():
	is_mad.emit()
