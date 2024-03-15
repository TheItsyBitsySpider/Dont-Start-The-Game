extends StaticBody2D

@export var normal_sfx_1: Resource
@export var normal_sfx_2: Resource
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

func _ready():
	sfx.connect("finished", _idle)
	var timer2 = get_tree().create_timer(6.0)
	timer2.timeout.connect(_type)

func _process(_delta):
	if player != null \
	and not effect_happened \
	and required_item != null \
	and player.item_held != null \
	and player.item_held.scene_file_path == required_item.resource_path:
		play_effect.emit()
		effect_happened = true

func _type():
	if sfx.playing:
		return
	var normal_sfx_list := [ normal_sfx_1, normal_sfx_2 ]
	var i := rng.randi_range(0, len(normal_sfx_list) - 1)
	sfx.set_stream(normal_sfx_list[i])
	sfx.volume_db = -10.0
	sfx.play()

func _idle():
	var timer2 = get_tree().create_timer(rng.randf_range(0.5, 2.0))
	timer2.timeout.connect(_type)

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
	var angry_sfx_list := [ angry_sfx_1, angry_sfx_2 ]
	if not sfx.stream in angry_sfx_list:
		var j := rng.randi_range(0, len(angry_sfx_list) - 1)
		sfx.stop()
		sfx.set_stream(angry_sfx_list[j])
		sfx.volume_db = 0.0
		sfx.play()

func _anger_helper():
	speech_cloud.texture = null
	speech_cloud.visible = false
	timer = null

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body is Area2D:
		body = body.get_parent()
	if body is Area2D:
		return
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
