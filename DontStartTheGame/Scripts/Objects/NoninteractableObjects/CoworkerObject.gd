extends StaticBody2D

@export var anger_effect_sprite_1: Resource
@export var anger_effect_sprite_2: Resource
@export var angry_sfx_1: Resource
@export var angry_sfx_2: Resource
@export var required_item: PackedScene
@onready var speech_cloud := $SpeechCloud
@onready var sfx := $AudioStreamPlayer

var player = null
var effect
var effect_node
var effect_happened := false

var rng := RandomNumberGenerator.new()
var timer: SceneTreeTimer = null

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
	var anger_effect_sprite_list := [ anger_effect_sprite_1, anger_effect_sprite_2 ]
	var i := rng.randi_range(0, len(anger_effect_sprite_list) - 1)
	speech_cloud.texture = anger_effect_sprite_list[i]
	speech_cloud.visible = true
	if timer == null:
		timer = get_tree().create_timer(1.5)
		timer.timeout.connect(_anger_helper)
	else:
		timer.time_left = 1.5
	if not sfx.playing:
		var angry_sfx_list := [ angry_sfx_1, angry_sfx_2 ]
		var j := rng.randi_range(0, len(angry_sfx_list) - 1)
		sfx.set_stream(angry_sfx_list[j])
		sfx.play()

func _anger_helper():
	speech_cloud.texture = null
	speech_cloud.visible = false
	timer = null
