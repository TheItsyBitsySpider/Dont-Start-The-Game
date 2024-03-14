extends StaticBody2D

@onready var popup_node := $Popup

var player = null
var effect
var effect_node

signal play_effect

func _on_interact_area_body_entered(body):
	player = body
	player.nearby_interactables.append(self)
	popup_node.visible = true

func _on_interact_area_body_exited(_body):
	player.nearby_interactables.erase(self)
	player = null
	popup_node.visible = false

func _on_give_item_effect_play_effect():
	play_effect.emit()
