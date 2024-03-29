extends Node2D

@export var normal_theme: Resource
@export var boss_theme: Resource
@export var starting_level: PackedScene
@export var rule_completed_sfx_1: Resource
@export var rule_completed_sfx_2: Resource
@export var level_completed_sfx_1: Resource
@export var level_completed_sfx_2: Resource
@export var level_completed_sfx_3: Resource
@export var level_completed_sfx_4: Resource
@onready var player := $PlayerCharacter
@onready var current_level = null
@onready var elevator_tooltip_container := $CanvasLayer/ElevatorTooltipContainer
@onready var elevator_tooltip := $CanvasLayer/ElevatorTooltipContainer/ElevatorTooltip
@onready var inventory_manager := $CanvasLayer/InventoryManager
@onready var rule_box := $CanvasLayer/RuleBox
@onready var rules_label := $CanvasLayer/RuleBox/RuleListerLabel
@onready var rules_list := $CanvasLayer/RuleBox/RuleLister
@onready var description_box := $CanvasLayer/DescriptionBox
@onready var description_text := $CanvasLayer/DescriptionBox/DescriptionText
@onready var reset_level_container := $CanvasLayer/ResetLevelContainer
@onready var reset_level_box := $CanvasLayer/ResetLevelBox
@onready var reset_level_label := $CanvasLayer/ResetLevelContainer/ResetLevelLabel
@onready var music_player := $BackgroundMusic

var rng := RandomNumberGenerator.new()

func _ready():
	call_deferred("resize")
	RenderingServer.set_default_clear_color(Color.hex(0x212123ff))
	get_tree().get_root().size_changed.connect(resize)
	player.add_to_inventory.connect(inventory_manager.add_item)
	player.remove_from_inventory.connect(inventory_manager.remove_item)
	player.change_selected_inventory_slot.connect(inventory_manager.change_selected)
	inventory_manager.change_selected(0)
	load_level(starting_level)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var bounds := Rect2(reset_level_box.position, reset_level_box.size)
		if bounds.has_point(event.position) and reset_level_box.visible:
			load_level(load(current_level.scene_file_path))

func _on_rule_completed():
	var rule_completed_sfx_list := [ rule_completed_sfx_1, rule_completed_sfx_2 ]
	var i := rng.randi_range(0, len(rule_completed_sfx_list) - 1)
	play_sound_effect(rule_completed_sfx_list[i])
	update_rules()

func _on_level_completed():
	var timer: SceneTreeTimer = get_tree().create_timer(0.5)
	timer.timeout.connect(_on_level_completed_helper)
	current_level.unlock_elevator()

func _on_level_completed_helper():
	var level_completed_sfx_list := [
		level_completed_sfx_1,
		level_completed_sfx_2,
		level_completed_sfx_3,
		level_completed_sfx_4
	]
	var i := rng.randi_range(0, len(level_completed_sfx_list) - 1)
	play_sound_effect(level_completed_sfx_list[i])

func update_rules():
	var rules = current_level.rule_manager.get_children()
	var rules_text = ""
	var rule_completion_count = 0
	for rule in rules:
		if not rule.complete_rule.is_connected(_on_rule_completed):
			rule.complete_rule.connect(_on_rule_completed)
		if rule.rule_completed:
			rule_completion_count += 1
			rules_text += "[s]" + rule.rule_text + "[/s]"
		else:
			rules_text += rule.rule_text
		rules_text += "\n"
	rules_list.set_text(rules_text.replace("\\n", "\n"))
	if rule_completion_count >= len(rules) \
	and current_level.level_elevator.is_locked:
		_on_level_completed()

func load_level(level):
	get_tree().call_group("Residuals", "on_level_exit")
	player.frozen = true
	player.inventory_items = []
	player.item_held = null
	for inventory_slot in inventory_manager.get_children():
		inventory_slot.remove_item()
	description_box.visible = false
	description_text.text = ""
	call_deferred("_load_level_helper", level)

func _load_level_helper(level):
	player.can_move = true
	var camera = player.get_camera() as Camera2D
	camera.position_smoothing_speed = 1
	camera.position_smoothing_enabled = false
	camera.position = Vector2.ZERO
	if current_level != null:
		current_level.queue_free()
	current_level = level.instantiate()
	player.current_level = current_level
	add_child(current_level)
	if music_player.stream.resource_path == boss_theme.resource_path:
		change_music(normal_theme)
	if current_level.name == "EndingScreen":
		set_gui_visibility(false)
		remove_child(player)
		return
	set_gui_visibility(false)
	player.visible = false
	current_level.visible = false
	elevator_tooltip.text = "[center]" + current_level.elevator_tooltip + "[/center]"
	elevator_tooltip_container.visible = true
	current_level.level_elevator.relinquished_control.connect(_on_elevator_relinquished_control)
	player.position = current_level.get_spawnpoint()
	update_rules()
	update_connections()

func _on_elevator_relinquished_control():
	set_gui_visibility(true)
	player.visible = true
	current_level.visible = true
	elevator_tooltip_container.visible = false
	player.unfreeze()

func update_connections():
	player.add_to_inventory.connect(current_level._on_main_character_add_to_inventory)

func set_gui_visibility(visibility: bool):
	for inventory_slot in inventory_manager.get_children():
		inventory_slot.visible = visibility
	rule_box.visible = visibility
	reset_level_container.visible = visibility
	reset_level_box.visible = visibility

func resize():
	elevator_tooltip_container.size = get_viewport_rect().size
	if get_viewport_rect().size.x >= 1600:
		elevator_tooltip.set("theme_override_font_sizes/normal_font_size", 48)
		rule_box.position = Vector2(32, 32)
		rule_box.size = Vector2(672, 304)
		rules_label.set("theme_override_font_sizes/font_size", 40)
		rules_list.position = Vector2(40, 54)
		rules_list.size = Vector2(608, 234)
		rules_list.set("theme_override_font_sizes/normal_font_size", 32)
		for i in range(inventory_manager.get_children().size()):
			inventory_manager.get_children()[i].position.x = 720 + 108 * i
			inventory_manager.get_children()[i].position.y = 32
		description_box.size = Vector2(800, 192)
		description_box.position.y = get_viewport_rect().size.y - description_box.size.y - 32
		description_text.set("theme_override_font_sizes/normal_font_size", 32)
		reset_level_container.position = Vector2(40, 32)
		reset_level_box.size = Vector2(288, 24)
		reset_level_label.set("theme_override_font_sizes/font_size", 32)
	else:
		elevator_tooltip.set("theme_override_font_sizes/normal_font_size", 32)
		rule_box.position = Vector2(16, 16)
		rule_box.size = Vector2(528, 224)
		rules_label.set("theme_override_font_sizes/font_size", 32)
		rules_list.position = Vector2(32, 46)
		rules_list.size = Vector2(472, 162)
		rules_list.set("theme_override_font_sizes/normal_font_size", 25)
		for i in range(inventory_manager.get_children().size()):
			inventory_manager.get_children()[i].position.x = 560 + 108 * i
			inventory_manager.get_children()[i].position.y = 16
		description_box.size = Vector2(608, 128)
		description_box.position.y = get_viewport_rect().size.y - description_box.size.y - 16
		description_text.set("theme_override_font_sizes/normal_font_size", 28)
		reset_level_container.position = Vector2(32, 16)
		reset_level_box.size = Vector2(224, 16)
		reset_level_label.set("theme_override_font_sizes/font_size", 25)
	description_box.position.x = get_viewport_rect().size.x / 2 - description_box.size.x / 2
	description_text.position = Vector2(24, 16)
	description_text.size.x = description_box.size.x - description_text.position.x * 2
	description_text.size.y = description_box.size.y - description_text.position.y * 2
	reset_level_container.size.x = get_viewport_rect().size.x - reset_level_container.position.x * 2
	reset_level_container.size.y = get_viewport_rect().size.y - reset_level_container.position.y * 2
	reset_level_box.position.x = reset_level_container.position.x
	reset_level_box.position.y = reset_level_container.position.y \
	+ reset_level_container.size.y - reset_level_box.size.y

func play_sound_effect(sound_effect: Resource):
	var sfx := AudioStreamPlayer.new()
	add_child(sfx)
	sfx.set_stream(sound_effect)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)

func change_music(music: Resource):
	music_player.stream = music
	music_player.play()
