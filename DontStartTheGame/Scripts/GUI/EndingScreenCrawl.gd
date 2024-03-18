extends RichTextLabel

@onready var text_timer = $Timer

func _ready():
	text_timer.start()

func _on_timer_timeout():
	visible_characters += 1
	if visible_characters >= len(text):
		text_timer.stop()
