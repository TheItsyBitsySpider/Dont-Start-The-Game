extends RichTextLabel

@onready var text_timer = $Timer

func _ready():
	call_deferred("resize")
	get_tree().get_root().size_changed.connect(resize)
	text_timer.start()

func _on_timer_timeout():
	visible_characters += 1
	if visible_characters >= len(text):
		text_timer.stop()

func resize():
	if get_viewport_rect().size.x >= 1600:
		position = Vector2(96, 80)
		set("theme_override_font_sizes/normal_font_size", 48)
	else:
		position = Vector2(64, 48)
		set("theme_override_font_sizes/normal_font_size", 32)
	size.x = get_viewport_rect().size.x - position.x * 2
	size.y = get_viewport_rect().size.y - position.y * 2
