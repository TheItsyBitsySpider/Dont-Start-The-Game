extends StaticBody2D

@export var normal_sprite: Resource
@export var spilled_sprite_1: Resource
@export var spilled_sprite_2: Resource
@export var spilled_sprite_3: Resource
@export var splash_sfx: Resource
@onready var sprite := $Sprite2D
@onready var give_item_effect := $GiveItemEffect
@onready var popup_node := $Popup

var player = null
var effect
var effect_node

signal play_effect
signal play_spill_effect

func _on_interact_area_body_entered(body):
	if body is CharacterBody2D:
		player = body
		player.nearby_interactables.append(self)
		popup_node.visible = true

func _on_interact_area_body_exited(body):
	if body is CharacterBody2D:
		player.nearby_interactables.erase(self)
		player = null
		popup_node.visible = false

func _on_give_item_effect_play_effect():
	_play_splash_sfx()
	play_effect.emit()

func spill():
	var sprite_list := [
		normal_sprite,
		spilled_sprite_1,
		spilled_sprite_2,
		spilled_sprite_3
	]
	var i := sprite_list.find(sprite.texture)
	if i + 1 < len(sprite_list):
		sprite.texture = sprite_list[i + 1]
	_play_splash_sfx()
	play_effect.emit()
	play_spill_effect.emit()

func _play_splash_sfx():
	var sfx := AudioStreamPlayer.new()
	add_child(sfx)
	sfx.set_stream(splash_sfx)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)
