extends StaticBody2D

@export_multiline var speech: String = "Hello, world!"

@onready var speech_box = $SpeechBubble
@onready var speech_dialogue = $SpeechBubble/Dialogue

var player = null
var monologue = false
var speech_sentences = []
var effect
var effect_node
var effect_happened := false

var rng := RandomNumberGenerator.new()
var timer: SceneTreeTimer = null

signal is_mad
signal play_effect

func _ready():
	speech_sentences = speech.split("\n")

func _process(delta):
	if monologue:
		if Input.is_action_just_pressed('interact'):
			show_next_line()


func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer == 5:
		player = body
		start_speech()

func start_speech():
	player.can_move = false
	var camera = player.get_camera() as Camera2D
	camera.position_smoothing_speed = 1
	camera.position_smoothing_enabled = true
	camera.position = position - player.position
	
	speech_box.visible = true
	show_next_line()
	
	monologue = true
	

func show_next_line():
	if speech_sentences.is_empty():
		player.can_move = true
		monologue = false
		speech_box.visible = false
		var camera = player.get_camera() as Camera2D
		camera.position_smoothing_speed = 1
		camera.position_smoothing_enabled = false
		camera.position = Vector2.ZERO
	else:
		speech_dialogue.text = speech_sentences[0]
		speech_sentences.remove_at(0)

func _on_interact_area_body_exited(_body):
	if player != null:
		player = null
