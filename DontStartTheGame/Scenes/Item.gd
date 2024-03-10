extends Sprite2D

@onready var popup_node = $Popup
@onready var scene_ID := scene_file_path

var player = null

var effect
var effect_node

signal play_effect

func _on_area_2d_body_entered(body):
	player = body
	player.nearby_items.append(self)
	popup_node.visible = true

func _on_area_2d_body_exited(_body):
	player.nearby_items.erase(self)
	player = null
	popup_node.visible = false

func _on_effect_effect_played():
	play_effect.emit()
