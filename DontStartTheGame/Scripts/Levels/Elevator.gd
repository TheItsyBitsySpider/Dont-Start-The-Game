extends Area2D

@export var grind_sfx: Resource
@export var arrive_sfx: Resource
@export var open_sfx: Resource
@onready var doors := $Doors
@onready var popup := $Popup
@onready var elevator_room := $ElevatorRoom
@onready var door_collision := $DoorCollision

signal relinquished_control

var has_control := true
var is_locked := true

var doors_closed_at_least_once_flag := false

func _ready():
	_on_arrived()

func _on_arrived():
	lock_elevator()
	call_deferred("play_sound_effect", grind_sfx)
	var timer: SceneTreeTimer = get_tree().create_timer(4.9)
	timer.timeout.connect(_ding)

func _ding():
	call_deferred("play_sound_effect", arrive_sfx)
	var timer: SceneTreeTimer = get_tree().create_timer(1.0)
	timer.timeout.connect(_start_opening_doors)

func _start_opening_doors():
	call_deferred("play_sound_effect", open_sfx)
	var timer: SceneTreeTimer = get_tree().create_timer(0.2)
	timer.timeout.connect(_open_doors)

func _open_doors():
	doors.visible = false
	relinquished_control.emit()
	remove_child(door_collision)
	has_control = false

func _start_closing_doors():
	call_deferred("play_sound_effect", open_sfx)
	var timer: SceneTreeTimer = get_tree().create_timer(0.2)
	timer.timeout.connect(_close_doors)

func _close_doors():
	doors.visible = true
	add_child(door_collision)
	if doors_closed_at_least_once_flag:
		set_deferred("monitorable", true)
		set_deferred("monitoring", true)
	doors_closed_at_least_once_flag = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and popup.visible:
		get_parent().change_level()

func lock_elevator():
	is_locked = true
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)

func unlock_elevator():
	is_locked = false
	var timer: SceneTreeTimer = get_tree().create_timer(1.5)
	timer.timeout.connect(_start_opening_doors)

func play_sound_effect(sound_effect: Resource):
	var sfx := AudioStreamPlayer.new()
	add_child(sfx)
	sfx.set_stream(sound_effect)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)

func show_popup():
	popup.visible = true

func hide_popup():
	popup.visible = false

func _on_body_entered(body):
	if body is CharacterBody2D:
		show_popup()

func _on_body_exited(body):
	if body is CharacterBody2D:
		hide_popup()

func _on_elevator_room_body_exited(body):
	if body is CharacterBody2D:
		_start_closing_doors()
		elevator_room.body_exited.disconnect(_on_elevator_room_body_exited)

func _on_elevator_room_deep_body_entered(body):
	if body is CharacterBody2D and not doors.visible \
	and doors_closed_at_least_once_flag:
		_start_closing_doors()
