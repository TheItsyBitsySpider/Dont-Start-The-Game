extends StaticBody2D

@export var normal_sprite: Resource
@export var special_sprite_1: Resource
@export var special_sprite_2: Resource
@export var special_sprite_3: Resource
@export var normal_sfx: Resource
@export var item_effect: Node2D
@onready var sprite := $Sprite2D
@onready var popup_node := $Popup

var player = null
var effect
var effect_node

signal play_effect
signal play_spill_effect

func _process(_delta):
	if item_effect == null:
		return
	popup_node.visible = false
	if player != null and player.item_held != null and item_effect != null \
	and player.item_held.scene_file_path == item_effect.required_item.resource_path:
		popup_node.visible = true
		if not player.nearby_interactables.has(self):
			player.nearby_interactables.append(self)

func _on_interact_area_body_entered(body):
	if body is CharacterBody2D:
		player = body
		if item_effect == null:
			player.nearby_interactables.append(self)
			popup_node.visible = true

func _on_interact_area_body_exited(body):
	if body is CharacterBody2D:
		player.nearby_interactables.erase(self)
		player = null
		if item_effect == null:
			popup_node.visible = false

func _on_give_item_effect_play_effect():
	_play_normal_sfx()
	play_effect.emit()

func cycle():
	var sprite_list := [
		normal_sprite,
		special_sprite_1,
		special_sprite_2,
		special_sprite_3
	]
	var i := sprite_list.find(sprite.texture)
	if i + 1 < len(sprite_list) and sprite_list[i + 1] != null:
		sprite.texture = sprite_list[i + 1]
	_play_normal_sfx()
	play_effect.emit()
	play_spill_effect.emit()

func _play_normal_sfx():
	var sfx := AudioStreamPlayer.new()
	add_child(sfx)
	sfx.set_stream(normal_sfx)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)
