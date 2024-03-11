extends StaticBody2D

@onready var popup_node := $Popup

var player = null
var effect
var effect_node

signal play_effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_interact_area_body_entered(body):
	player = body
	player.nearby_interactables.append(self)
	popup_node.visible = true


func _on_interact_area_body_exited(body):
	player.nearby_interactables.erase(self)
	player = null
	popup_node.visible = false


func _on_give_item_effect_play_effect():
	play_effect.emit()
