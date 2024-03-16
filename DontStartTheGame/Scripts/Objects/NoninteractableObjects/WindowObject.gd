extends StaticBody2D

@export var description := "None of the rules say defenestration isn’t allowed."
@export var broken_window_sprite: Resource
@export var duck_in_level: Sprite2D
@onready var item_crash_sfx := $CrashSFX
@onready var window_break_sfx := $BreakSFX
@onready var window_sprite := $Sprite2D

var player = null
var effect
var effect_node
var effect_happened := false
var saved_item_position
var broken := false

signal play_effect

# Centers window on tile so it fits neatly with the walls
func _ready():
	position = get_parent().map_to_local(get_parent().local_to_map(position))
	if duck_in_level != null:
		saved_item_position = duck_in_level.position

func _on_interact_area_body_entered(body):
	if "collision_layer" not in body:
		return
	if body.collision_layer == 6:
		play_effect.emit(body.get_parent())
		if not broken:
			window_break_sfx.play()
		else:
			item_crash_sfx.play()
		broken = true
		window_sprite.texture = broken_window_sprite
		if body.get_parent() == duck_in_level:
			# Can add a message chastising player later
			duck_in_level.velocity = Vector2.ZERO
			get_parent().remove_child(duck_in_level)
			var timer: SceneTreeTimer = get_tree().create_timer(0.5)
			timer.timeout.connect(_return_duck)
		else:
			body.get_parent().get_parent().remove_child(body.get_parent())
	elif body.collision_layer == 5:
		player = body
		player.nearby_objects_with_descriptions.append(self)

func _return_duck():
	duck_in_level.position = saved_item_position
	get_parent().add_child(duck_in_level)
	duck_in_level.process_mode = Node.PROCESS_MODE_DISABLED
	duck_in_level.self_modulate.a = 0.0
	_lock = false
	_fade_in_duck()

var _lock := false

func _fade_in_duck():
	if not _lock and duck_in_level.self_modulate.a >= 0.5:
		var sfx := AudioStreamPlayer.new()
		get_parent().add_child(sfx)
		sfx.set_stream(duck_in_level.effect_node.squeak_sfx)
		sfx.play()
		sfx.connect("finished", sfx.queue_free)
		_lock = true
	if duck_in_level.self_modulate.a >= 1.0:
		duck_in_level.self_modulate.a = 1.0
		duck_in_level.process_mode = Node.PROCESS_MODE_INHERIT
		return
	duck_in_level.self_modulate.a = duck_in_level.self_modulate.a + 0.03
	var timer: SceneTreeTimer = get_tree().create_timer(0.01)
	timer.timeout.connect(_fade_in_duck)

func _on_interact_area_body_exited(_body):
	if player != null:
		player.nearby_objects_with_descriptions.erase(self)
		player = null
