extends TextureRect

@export var description_to_show: RichTextLabel

@onready var sprite := $ItemSprite
@onready var highlight_effect := $Highlight

var item_ID = null
var item_effect = null
var item_description = ""

func _ready():
	sprite.visible = false
	highlight_effect.visible = false
	connect("mouse_entered", show_description)
	connect("mouse_exited", hide_description)

func add_item(item):
	sprite.texture = item.texture
	sprite.visible = true
	item_ID = item.scene_ID
	item_effect = item.effect
	item_description = item.description

func remove_item():
	sprite.texture = null
	sprite.visible = false
	item_ID = null
	item_effect = null
	item_description = ""

func highlight():
	highlight_effect.visible = true

func unhighlight():
	highlight_effect.visible = false

func show_description():
	description_to_show.text = item_description

func hide_description():
	description_to_show.text = ""
