extends StaticBody2D

@export var boss_theme: Resource
@export_multiline var speech: String = "Hello, world!"

@onready var speech_box := $SpeechBubble
@onready var speech_dialogue := $SpeechBubble/Dialogue
@onready var text_timer := $SpeechBubble/AnimateText

var player = null
var monologue = false
var has_started = false
var speech_sentences = []
var effect
var effect_node
var effect_happened := false

var rng := RandomNumberGenerator.new()
var timer: SceneTreeTimer = null
var stripped_text = RegEx.new()

signal is_mad
signal play_effect

func _ready():
	speech_sentences = speech.split("\n")
	stripped_text.compile("\\[.*?\\]")

func _process(_delta):
	if monologue:
		if Input.is_action_just_pressed('interact'):
			$SpeechBubble/Popup.visible = false
			show_next_line()

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer == 5 and not has_started:
		player = body
		has_started = true
		start_speech()

func start_speech():
	player.can_move = false
	var camera = player.get_camera() as Camera2D
	camera.position_smoothing_speed = 1
	camera.position_smoothing_enabled = true
	camera.position = position - player.position
	
	player.get_parent().change_music(boss_theme)
	
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
		speech_dialogue.visible_characters = 0
		text_timer.start()
		speech_sentences.remove_at(0)

func _on_interact_area_body_exited(_body):
	if player != null:
		player = null


func _on_animate_text_timeout():
	speech_dialogue.visible_characters += 1
	var stripped_speech_dialogue = stripped_text.sub(speech_dialogue.text, "", true)
	if speech_dialogue.visible_characters >= len(stripped_speech_dialogue):
		text_timer.stop()
		$SpeechBubble/Popup.visible = true


func _on_popup_visible_timeout():
	$SpeechBubble/Popup.visible = true
